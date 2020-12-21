import { BadRequestException, HttpException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { auth, driver, Driver, Transaction } from 'neo4j-driver';
import { ConfigKey, ConfigService } from '../config/config.service';
import { DocumentDefinition, Model } from 'mongoose';
import { User } from '../users/user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from '../movies/movie.schema';
import { Category } from '../categories/category.schema';
import { Comment } from "../comments/comment.schema";
import { ShowTime } from '../show-times/show-time.schema';
import { Theatre } from '../theatres/theatre.schema';
import { Reservation } from '../reservations/reservation.schema';
import { LocationDto } from '../common/location.dto';
import { catchError, exhaustMap, first, map, shareReplay, tap, toArray } from 'rxjs/operators';
import { concat, defer, identity, merge, Observable, of, partition, throwError } from 'rxjs';
import { UserPayload } from '../auth/get-user.decorator';
import { checkCompletedLogin, constants, getCoordinates } from '../common/utils';
import { Parameters } from 'neo4j-driver/types/query-runner';
import { SearchMoviesDto } from './search-movies.dto';
import { Person } from '../people/person.schema';

const FAVORITE_SCORE = 1;
const COMMENT_SCORE = (comment: DocumentDefinition<Comment>) => comment.rate_star;
const RESERVED_SCORE = 2;

function splitIdAndRests(idAndRests: IdAndRest[]): IdAndMap {
  const ids: string[] = idAndRests.map(r => r._id);

  const restById: Map<string, Record<string, any>> = idAndRests.reduce(
      (acc, e) => {
        const { _id, ...rest } = e;
        acc.set(_id, rest);
        return acc;
      },
      new Map<string, Record<string, any>>()
  );

  return { ids, restById };
}

type IdAndRest = {
  _id: string,
  [k: string]: any,
};

type IdAndMap = { ids: string[]; restById: Map<string, Record<string, any>> };

export type MovieAndExtraInfo = DocumentDefinition<Movie> & Record<string, any>;

@Injectable()
export class Neo4jService {
  private readonly logger = new Logger(Neo4jService.name);
  private readonly driver: Driver;

  constructor(
      configService: ConfigService,
      @InjectModel(User.name) private readonly userModel: Model<User>,
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
      @InjectModel(Category.name) private readonly categoryModel: Model<Category>,
      @InjectModel(Comment.name) private readonly commentModel: Model<Comment>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Person.name) private readonly personModel: Model<Person>,
  ) {
    try {
      this.driver = driver(
          configService.get(ConfigKey.NEO4J_URL),
          auth.basic(
              configService.get(ConfigKey.NEO4J_USER),
              configService.get(ConfigKey.NEO4J_PASSWORD),
          ),
          { disableLosslessIntegers: true },
      );
      this.logger.debug(`Done ${this.driver}`);
    } catch (e) {
      this.logger.debug(`Error ${e}`);
    }
  }

  ///
  /// START TRANSFER DATA
  ///

  async transferData(): Promise<void> {
    await this.runTransaction(txc =>
            txc.run(`
              MATCH (n)
              DETACH DELETE n`
            ),
        '[DELETE]',
    );

    await this.addCategories();
    await this.addPeople();
    await this.addMovies();
    await this.addUsers();
    await this.addComments();
    await this.addTheatres();
    await this.addShowTimes();
    await this.addReservations();
  }

  private async addUsers() {
    const users: DocumentDefinition<User>[] = await this.userModel.find({}).lean();
    await this.runTransaction(
        async txc => {
          for (const user of users) {
            await txc.run(
                `
                    MERGE(user: USER { _id: $_id })
                    ON CREATE SET
                        user.uid = $uid,
                        user.email = $email,
                        user.full_name = $full_name,
                        user.gender = $gender,
                        user.address = $address,
                        user.location = point({ latitude: toFloat($latitude), longitude: toFloat($longitude) })
                    ON MATCH SET
                        user.uid = $uid,
                        user.email = $email,
                        user.full_name = $full_name,
                        user.gender = $gender,
                        user.address = $address,
                        user.location = point({ latitude: toFloat($latitude), longitude: toFloat($longitude) })
                    
                    WITH user
                    
                    MATCH (o: USER)
                    WHERE o._id <> user._id AND o.gender = user.gender
                    WITH user, o
                    MERGE (user)-[r:SIMILAR_GENDER]-(o)
                    ON CREATE SET r.score = 1
                    ON MATCH SET r.score = r.score + 1
                    
                    WITH user, o, coalesce(distance(user.location, o.location), -1.0) AS d
                    WHERE 0 <= d AND d <= $max_distance
                    WITH user, o
                    MERGE (user)-[r:SIMILAR_LOCATION]-(o)
                    ON CREATE SET r.score = 3
                    ON MATCH SET r.score = r.score + 3
                `,
                {
                  _id: user._id.toString(),
                  uid: user.uid,
                  email: user.email ?? '',
                  full_name: user.full_name ?? '',
                  gender: user.gender ?? 'MALE',
                  address: user.address ?? '',
                  longitude: user.location?.coordinates?.[0] ?? null,
                  latitude: user.location?.coordinates?.[1] ?? null,
                  max_distance: constants.maxDistanceInMeters,
                }
            );
          }
        },
        `[USERS] ${users.length}`,
    );

    await this.runTransaction(
        async txc => {
          await txc.run(
              `
                    MATCH(u1:USER)-[r]-(u2:USER)
                    WITH u1, u2, r, sum(r.score) as score
                    DELETE r
                    MERGE (u1)-[rs:SIMILAR]-(u2)
                    ON CREATE SET rs.score = score
                    ON MATCH SET rs.score = score
                `,
              {},
          );
        },
        `[USERS] ${users.length}`,
    );

    await this.runTransaction(
        async txc => {
          for (const user of users) {
            const ids = Object.keys(user.favorite_movie_ids ?? {});
            for (const mov_id of ids) {
              await txc.run(
                  `
                    MATCH (user: USER { _id: $id  })
                    MATCH (mov: MOVIE { _id: $mov_id })
                    MERGE (user)-[r:INTERACTIVE]->(mov)
                    ON CREATE SET r.score = $score
                    ON MATCH SET r.score = r.score + $score
                    RETURN mov.title, user.title
                `,
                  {
                    id: user._id.toString(),
                    mov_id,
                    score: FAVORITE_SCORE,
                  },
              );
            }
          }
        },
        `[USERS] ${users.length}`,
    );
  }

  private async runTransaction(operation: (txc: Transaction) => Promise<any>, tag?: string): Promise<void> {
    const session = this.driver.session();
    const transaction = session.beginTransaction();

    try {
      const result = await operation(transaction);
      await transaction.commit();
      this.logger.debug(`${tag} success ${JSON.stringify(result)}`);
    } catch (e) {
      await transaction.rollback();
      this.logger.debug(`${tag} error ${e}`);
      throw e;
    } finally {
      await session.close();
    }
  }

  private async addMovies() {
    const movies = await this.movieModel.find({})
        .lean()
        .populate({
          path: 'categories',
          populate: { path: 'category_id' },
        });

    await this.runTransaction(async txc => {
      let i = 0;

      for (const mov of movies) {
        this.logger.debug(`movies1 ${i++}/${movies.length}`);
        await txc.run(
            `
              MERGE(mov: MOVIE { _id: $_id })
              ON CREATE SET
                mov.title = $title,
                mov.trailer_video_url = $trailer_video_url,
                mov.poster_url = $poster_url,
                mov.overview = $overview,
                mov.released_date = apoc.date.fromISO8601($released_date),
                mov.duration = $duration,
                mov.original_language = $original_language,
                mov.age_type = $age_type,
                mov.total_rate = $total_rate,
                mov.rate_star = $rate_star,
                mov.total_favorite = $total_favorite,
                mov.is_active = $is_active
              ON MATCH SET
                mov.title = $title,
                mov.trailer_video_url = $trailer_video_url,
                mov.poster_url = $poster_url,
                mov.overview = $overview,
                mov.released_date = apoc.date.fromISO8601($released_date),
                mov.duration = $duration,
                mov.original_language = $original_language,
                mov.age_type = $age_type,
                mov.total_rate = $total_rate,
                mov.rate_star = $rate_star,
                mov.total_favorite = $total_favorite,
                mov.is_active = $is_active
            `,
            {
              _id: mov._id.toString(),
              title: mov.title ?? '',
              trailer_video_url: mov.trailer_video_url ?? '',
              poster_url: mov.poster_url ?? '',
              overview: mov.overview ?? '',
              released_date: (mov.released_date ?? new Date()).toISOString(),
              duration: mov.duration ?? 0,
              original_language: mov.original_language ?? 'en',
              age_type: mov.age_type ?? 'P',
              total_rate: mov.total_rate ?? 0,
              rate_star: mov.rate_star ?? 0.0,
              total_favorite: mov.total_favorite ?? 0,
              is_active: mov.is_active ?? true,
            },
        );
      }
    }, `[MOVIES] [1] ${movies.length}`);

    await this.runTransaction(async txc => {
      let i = 0;

      for (const mov of movies) {
        this.logger.debug(`movies2 ${i++}/${movies.length}`);

        const ids: string[] = (mov as any).categories.map(c => c.category_id._id.toString());

        for (const cat_id of ids) {
          await txc.run(
              `
                MATCH (cat: CATEGORY { _id: $cat_id  })
                MATCH (mov: MOVIE { _id: $mov_id })
                MERGE (mov)-[r:IN_CATEGORY]->(cat)
                RETURN mov.title
            `,
              {
                cat_id,
                mov_id: mov._id.toString(),
              },
          );
        }
      }
    }, `[MOVIES] [2] ${movies.length}`);

    await this.runTransaction(async txc => {
      let i = 0;

      for (const mov of movies) {
        this.logger.debug(`movies3 ${i++}/${movies.length}`);

        const actors: string[] = mov.actors.map(i => i.toString());
        for (const p_id of actors) {
          await txc.run(
              `
                MATCH (p: PERSON { _id: $p_id  })
                MATCH (mov: MOVIE { _id: $mov_id })
                MERGE (p)-[r:ACTED_IN]->(mov)
                RETURN mov.title, p.full_name
            `,
              {
                p_id,
                mov_id: mov._id.toString(),
              },
          );
        }

        const directors: string[] = mov.directors.map(i => i.toString());
        for (const p_id of directors) {
          await txc.run(
              `
                MATCH (p: PERSON { _id: $p_id  })
                MATCH (mov: MOVIE { _id: $mov_id })
                MERGE (p)-[r:DIRECTED]->(mov)
                RETURN mov.title, p.full_name
            `,
              {
                p_id,
                mov_id: mov._id.toString(),
              },
          );
        }
      }
    }, `[MOVIES] [3] ${movies.length}`);
  }

  private async addCategories(): Promise<void> {
    const categories = await this.categoryModel.find({}).lean();

    await this.runTransaction(async txc => {
      for (const cat of categories) {
        await txc.run(
            `
              MERGE(cat: CATEGORY { _id: $_id })
              ON CREATE SET
                cat.name = $name
              ON MATCH SET
                cat.name = $name
            `,
            {
              _id: cat._id.toString(),
              name: cat.name,
            },
        );
      }
    }, `[CATEGORIES] ${categories.length}`);
  }

  private async addComments() {
    const comments: DocumentDefinition<Comment>[] = await this.commentModel.find({}, {
      movie: 1,
      user: 1,
      rate_star: 1
    })
        .sort({ createdAt: -1 })
        .limit(1_000)
        .lean();

    await this.runTransaction(
        async txc => {
          let i = 0;

          for (const comment of comments) {
            this.logger.debug(`comments ${i++}/${comments.length}`);

            await txc.run(
                `
                  MATCH (mov: MOVIE { _id: $movie_id })
                  MATCH (user: USER { _id: $user_id })
                  MERGE (user)-[r:INTERACTIVE]->(mov)
                  ON CREATE SET r.score = $score
                  ON MATCH SET r.score = r.score + $score
                  RETURN mov.title, user.title, r
                `,
                {
                  movie_id: comment.movie.toString(),
                  user_id: comment.user.toString(),
                  score: COMMENT_SCORE(comment),
                },
            );
          }
        },
        `[COMMENTS] ${comments.length}`,
    )
  }

  private async addShowTimes() {
    const showTimes = await this.showTimeModel.find({}).lean();

    await this.runTransaction(
        async txc => {
          let i = 0;

          for (const st of showTimes) {
            this.logger.debug(`show-times1 ${i++}/${showTimes.length}`);

            await txc.run(
                `
                  MERGE(st: SHOW_TIME { _id: $id })
                  ON CREATE SET
                    st.room = $room,
                    st.start_time = apoc.date.fromISO8601($start_time),
                    st.end_time = apoc.date.fromISO8601($end_time)
                  ON MATCH SET
                    st.room = $room,
                    st.start_time = apoc.date.fromISO8601($start_time),
                    st.end_time = apoc.date.fromISO8601($end_time)
                `,
                {
                  id: st._id.toString(),
                  room: st.room ?? '',
                  start_time: st.start_time.toISOString(),
                  end_time: st.end_time.toISOString(),
                },
            );
          }
        },
        `[SHOW_TIMES] ${showTimes.length}`,
    );

    await this.runTransaction(
        async txc => {
          let i = 0;

          for (const st of showTimes) {
            this.logger.debug(`show-times2 ${i++}/${showTimes.length}`);

            await txc.run(
                `
                      MATCH (st: SHOW_TIME { _id: $id })
                      MATCH (mov: MOVIE { _id: $mov_id })
                      MATCH (t: THEATRE { _id: $theatre_id })
                      MERGE (mov)-[r1:HAS_SHOW_TIME]-(st)
                      MERGE (t)-[r2:HAS_SHOW_TIME]-(st)
                      RETURN r1, r2
                `,
                {
                  id: st._id.toString(),
                  mov_id: st.movie.toString(),
                  theatre_id: st.theatre.toString(),
                },
            );
          }
        },
        `[SHOW_TIMES] ${showTimes.length}`,
    );
  }

  private async addTheatres() {
    const theatres: DocumentDefinition<Theatre>[] = await this.theatreModel.find({}).lean();

    await this.runTransaction(
        async txc => {
          for (const t of theatres) {
            await txc.run(
                `
                    MERGE (t: THEATRE { _id: $id })
                    ON CREATE SET
                      t.name = $name,
                      t.address = $address,
                      t.location = point({ latitude: toFloat($latitude), longitude: toFloat($longitude) })
                    ON MATCH SET
                      t.name = $name,
                      t.address = $address,
                      t.location = point({ latitude: toFloat($latitude), longitude: toFloat($longitude) })
                    RETURN t.name
                `,
                {
                  id: t._id.toString(),
                  name: t.name ?? '',
                  address: t.address ?? '',
                  latitude: t.location?.coordinates?.[1] ?? null,
                  longitude: t.location?.coordinates?.[0] ?? null,
                }
            );
          }
        },
        `[THEATRES] ${theatres.length}`,
    );
  }

  private async addReservations() {
    const reservations: DocumentDefinition<Reservation>[] = await this.reservationModel.find({})
        .populate('show_time')
        .lean();

    await this.runTransaction(
        async txc => {
          for (const r of reservations) {
            const showTime = r.show_time as ShowTime;

            const r1 = await txc.run(
                `
                  MATCH (u: USER { _id: $uid })
                  MATCH (s: SHOW_TIME { _id: $sid })
                  MERGE (u)-[r:RESERVED]->(s)
                  RETURN r
              `,
                {
                  uid: r.user.toString(),
                  sid: showTime._id.toString(),
                }
            );

            const r2 = await txc.run(
                `
                  MATCH (mov: MOVIE { _id: $movie_id })
                  MATCH (user: USER { _id: $user_id })
                  MERGE (user)-[r:INTERACTIVE]->(mov)
                  ON CREATE SET r.score = $score
                  ON MATCH SET r.score = r.score + $score
                  RETURN mov.title, user.title, r
              `,
                {
                  movie_id: showTime.movie.toString(),
                  user_id: r.user.toString(),
                  score: RESERVED_SCORE,
                },
            );
          }
        },
        `[RESERVATIONS] ${reservations.length}`,
    );
  }

  private async addPeople() {
    const people = await this.personModel.find({}).lean();

    await this.runTransaction(async txc => {
      let i = 0;
      
      for (const person of people) {
        this.logger.debug(`people ${i++}/${people.length}`);
        await txc.run(
            `
              MERGE(cat: PERSON { _id: $_id })
              ON CREATE SET
                cat.full_name = $name
              ON MATCH SET
                cat.full_name = $name
            `,
            {
              _id: person._id.toString(),
              name: person.full_name,
            },
        );
      }
    }, `[PEOPLE] ${people.length}`);
  }

  ///
  /// END TRANSFER DATA
  ///

  ///
  /// START RECOMMENDED
  ///

  getRecommendedMovies(
      dto: LocationDto,
      userPayload: UserPayload
  ): Observable<MovieAndExtraInfo[]> {
    const center: [number, number] | null = getCoordinates(dto);
    const user = checkCompletedLogin(userPayload);

    const isInteracted$ = this.userInteractedMovie(user).pipe(shareReplay(1));
    const [interacted$, notInteracted$] = partition(isInteracted$, identity);

    const queryInteracted: () => [string, Parameters] = () => {
      if (center) {
        return [
          `
          MATCH (u1:USER { _id: $id })-[r1:INTERACTIVE]->(m:MOVIE)
          WITH u1, avg(r1.score) AS u1_mean
          
          MATCH (u1)-[r1:INTERACTIVE]->(m:MOVIE)<-[r2:INTERACTIVE]-(u2:USER)
          WITH u1, u1_mean, u2, collect({ r1: r1, r2: r2 }) AS iteractions WHERE size(iteractions) > 1
          
          MATCH (u2)-[r2:INTERACTIVE]->(m:MOVIE)
          WITH u1, u1_mean, u2, avg(r2.score) AS u2_mean, iteractions
          
          UNWIND iteractions AS r
          
          WITH sum( (r.r1.score - u1_mean) * (r.r2.score - u2_mean) ) AS nom,
               sqrt( sum((r.r1.score - u1_mean) ^ 2) * sum((r.r2.score - u2_mean) ^ 2) ) AS denom,
               u1, u2 WHERE denom <> 0
            
          WITH u1, u2, nom / denom AS pearson
          ORDER BY pearson DESC LIMIT 15
          
          MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE), (m)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
          WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
          WITH m, pearson, r,
              datetime({ epochMillis: st.start_time }) AS startTime,
              datetime({ epochMillis: st.end_time }) AS endTime,
              datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) AS startOfDay,
              coalesce(distance(point({ latitude: $lat, longitude: $lng }), t.location), -1.0) AS distance
          WHERE
              0 <= distance AND distance <= $max_distance
              AND startTime >= startOfDay
              AND endTime <= startOfDay + duration({ days: 4 })
          
          WITH m, pearson, r, distance
          RETURN m._id AS _id, sum(pearson * r.score) AS recommendation, pearson, r.score AS score, null AS cats, distance
          ORDER BY recommendation DESC LIMIT 24
          
          UNION ALL
          
          MATCH (u:USER { _id: $id })-[r:INTERACTIVE]->(m:MOVIE)
          WITH u, avg(r.score) AS mean
          
          MATCH (u)-[r:INTERACTIVE]->(m:MOVIE)-[:IN_CATEGORY]->(cat:CATEGORY)
          WHERE r.score > mean
          
          WITH u, cat, COUNT(*) AS score
          
          MATCH (cat)<-[:IN_CATEGORY]-(rec:MOVIE), (rec)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
          WHERE NOT exists((u)-[:INTERACTIVE]->(rec))
          WITH rec, score, cat,
               datetime({ epochMillis: st.start_time }) AS startTime,
               datetime({ epochMillis: st.end_time }) AS endTime,
               datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) AS startOfDay,
               coalesce(distance(point({ latitude: $lat, longitude: $lng }), t.location), -1.0) AS distance
          WHERE
              0 <= distance AND distance <= $max_distance
              AND startTime >= startOfDay
              AND endTime <= startOfDay + duration({ days: 4 })
          
          WITH sum(score) AS score, rec, cat, distance
          RETURN rec._id AS _id, score AS recommendation, null AS pearson, score, collect(DISTINCT cat.name) AS cats, distance
          ORDER BY recommendation DESC LIMIT 24
          
          UNION ALL
          
          MATCH (u1:USER { _id: $id })-[r1:INTERACTIVE]->(m:MOVIE)
          WITH u1, avg(r1.score) AS u1_mean
          
          MATCH (u1)-[r1:INTERACTIVE]->(m:MOVIE)<-[r2:INTERACTIVE]-(u2:USER)
          WITH u1, u1_mean, u2, collect({ r1: r1, r2: r2 }) AS iteractions WHERE size(iteractions) > 1
          
          MATCH (u2)-[r2:INTERACTIVE]->(m:MOVIE)
          WITH u1, u1_mean, u2, avg(r2.score) AS u2_mean, iteractions
          
          UNWIND iteractions AS r
          
          WITH sum( (r.r1.score - u1_mean) * (r.r2.score - u2_mean) ) AS nom,
               sqrt( sum((r.r1.score - u1_mean) ^ 2) * sum((r.r2.score - u2_mean) ^ 2) ) AS denom,
               u1, u2 WHERE denom <> 0
            
          WITH u1, u2, nom / denom AS pearson
          ORDER BY pearson DESC LIMIT 15
          
          MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE) WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
          WITH m, pearson, r
          RETURN m._id AS _id, sum(pearson * r.score) AS recommendation, pearson, r.score AS score, null AS cats, null as distance
          ORDER BY recommendation DESC LIMIT 24
          `,
          {
            id: user._id.toString(),
            lng: center[0],
            lat: center[1],
            max_distance: constants.maxDistanceInMeters,
          },
        ];
      } else {
        return [
          `
          MATCH (u1:USER { _id: $id })-[r1:INTERACTIVE]->(m:MOVIE)
          WITH u1, avg(r1.score) AS u1_mean
          
          MATCH (u1)-[r1:INTERACTIVE]->(m:MOVIE)<-[r2:INTERACTIVE]-(u2:USER)
          WITH u1, u1_mean, u2, collect({ r1: r1, r2: r2 }) AS iteractions WHERE size(iteractions) > 1
          
          MATCH (u2)-[r2:INTERACTIVE]->(m:MOVIE)
          WITH u1, u1_mean, u2, avg(r2.score) AS u2_mean, iteractions
          
          UNWIND iteractions AS r
          
          WITH sum( (r.r1.score - u1_mean) * (r.r2.score - u2_mean) ) AS nom,
               sqrt( sum((r.r1.score - u1_mean) ^ 2) * sum((r.r2.score - u2_mean) ^ 2) ) AS denom,
               u1, u2 WHERE denom <> 0
            
          WITH u1, u2, nom / denom AS pearson
          ORDER BY pearson DESC LIMIT 15
          
          MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE), (m)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
          WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
          WITH m, pearson, r,
              datetime({ epochMillis: st.start_time }) as startTime,
              datetime({ epochMillis: st.end_time }) as endTime,
              datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) as startOfDay
          WHERE startTime >= startOfDay AND endTime <= startOfDay + duration({ days: 4 })
          
          RETURN m._id AS _id, sum(pearson * r.score) AS recommendation, pearson, r.score AS score, null AS cats
          ORDER BY recommendation DESC LIMIT 24
          
          UNION ALL
          
          MATCH (u:USER { _id: $id })-[r:INTERACTIVE]->(m:MOVIE)
          WITH u, avg(r.score) AS mean
          
          MATCH (u)-[r:INTERACTIVE]->(m:MOVIE)-[:IN_CATEGORY]->(cat:CATEGORY)
          WHERE r.score > mean
          
          WITH u, cat, COUNT(*) AS score
          
          MATCH (cat)<-[:IN_CATEGORY]-(rec:MOVIE), (rec)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
          WHERE NOT exists((u)-[:INTERACTIVE]->(rec))
          WITH rec, score, cat,
               datetime({ epochMillis: st.start_time }) AS startTime,
               datetime({ epochMillis: st.end_time }) AS endTime,
               datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) AS startOfDay
          WHERE startTime >= startOfDay AND endTime <= startOfDay + duration({ days: 4 })
          
          WITH sum(score) AS score, rec, cat
          RETURN rec._id AS _id, score AS recommendation, null AS pearson, score, collect(DISTINCT cat.name) AS cats
          ORDER BY recommendation DESC LIMIT 24
          
          UNION ALL
          
          MATCH (u1:USER { _id: $id })-[r1:INTERACTIVE]->(m:MOVIE)
          WITH u1, avg(r1.score) AS u1_mean
          
          MATCH (u1)-[r1:INTERACTIVE]->(m:MOVIE)<-[r2:INTERACTIVE]-(u2:USER)
          WITH u1, u1_mean, u2, collect({ r1: r1, r2: r2 }) AS iteractions WHERE size(iteractions) > 1
          
          MATCH (u2)-[r2:INTERACTIVE]->(m:MOVIE)
          WITH u1, u1_mean, u2, avg(r2.score) AS u2_mean, iteractions
          
          UNWIND iteractions AS r
          
          WITH sum( (r.r1.score - u1_mean) * (r.r2.score - u2_mean) ) AS nom,
               sqrt( sum((r.r1.score - u1_mean) ^ 2) * sum((r.r2.score - u2_mean) ^ 2) ) AS denom,
               u1, u2 WHERE denom <> 0
            
          WITH u1, u2, nom / denom AS pearson
          ORDER BY pearson DESC LIMIT 15
          
          MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE) WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
          WITH m, pearson, r
          RETURN m._id AS _id, sum(pearson * r.score) AS recommendation, pearson, r.score AS score, null AS cats
          ORDER BY recommendation DESC LIMIT 24
          `,
          {
            id: user._id.toString(),
          },
        ];
      }
    };
    const queryNotInteracted: () => [string, Parameters] = () => {
      if (center) {
        return [
          `
            MATCH (u:USER { _id: $id })-[r:SIMILAR]-(other:USER)
            WITH other, sum(r.score) AS score
            
            MATCH (other)-[r:INTERACTIVE]->(m: MOVIE), (m)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
            WITH r.score + score AS recommendation, m, score, st, t,
                datetime({ epochMillis: st.start_time }) AS startTime,
                datetime({ epochMillis: st.end_time }) AS endTime,
                datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) AS startOfDay,
                coalesce(distance(point({ latitude: $lat, longitude: $lng }), t.location), -1.0) AS distance
            WHERE
                0 <= distance AND distance <= $max_distance
                AND startTime >= startOfDay
                AND endTime <= startOfDay + duration({ days: 4 })
            
            RETURN m._id AS _id, recommendation, score, distance
            ORDER BY recommendation DESC LIMIT 24
          `,
          {
            id: user._id.toString(),
            lng: center[0],
            lat: center[1],
            max_distance: constants.maxDistanceInMeters,
          },
        ];
      } else {
        return [
          `
            MATCH (u:USER { _id: $id })-[r:SIMILAR]-(other:USER)
            WITH other, sum(r.score) AS score
            
            MATCH (other)-[r:INTERACTIVE]->(m: MOVIE), (m)-[:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[:HAS_SHOW_TIME]-(t:THEATRE)
            WITH r.score + score AS recommendation, m, score, st, t,
                datetime({ epochMillis: st.start_time }) AS startTime,
                datetime({ epochMillis: st.end_time }) AS endTime,
                datetime.truncate('hour', datetime(), { minute: 0, second: 0, millisecond: 0, microsecond: 0 }) AS startOfDay
            WHERE startTime >= startOfDay AND endTime <= startOfDay + duration({ days: 4 })
            
            RETURN m._id AS _id, recommendation, score
            ORDER BY recommendation DESC LIMIT 24
          `,
          {
            id: user._id.toString(),
          },
        ];
      }
    };

    return merge(
        interacted$.pipe(map(queryInteracted)),
        notInteracted$.pipe(map(queryNotInteracted)),
    ).pipe(
        exhaustMap(([query, parameters]) => {
          const session = this.driver.rxSession();

          return concat(
              session
                  .run(query, parameters)
                  .records()
                  .pipe(
                      map(record =>
                          ({
                            ...record.toObject(),
                            _id: record.get('_id') as string,
                          })
                      ),
                      toArray(),
                      map(splitIdAndRests),
                      exhaustMap((idAndMap) => {
                            return this
                                .findMoviesInIds(idAndMap)
                                .pipe(
                                    map(movies => {
                                          const a1 = movies
                                              .filter(m => m.pearson !== null && m.pearson !== undefined)
                                              .sort((l, r) => r.recommendation - l.recommendation);

                                          const a2 = movies
                                              .filter(m => m.pearson === null || m.pearson === undefined)
                                              .sort((l, r) => r.recommendation - l.recommendation);

                                          const result = a1.concat(a2).distinct(v => v._id.toString());

                                          this.logger.debug(movies.length, '[]');
                                          this.logger.debug(a1.length, '[1]');
                                          this.logger.debug(a2.length, '[2]');
                                          this.logger.debug(result.length, '[*]');

                                          return result;
                                        }
                                    ),
                                );
                          },
                      ),
                  ),
              session.close() as Observable<never>,
          );
        }),
    );
  }

  private userInteractedMovie(user: User): Observable<boolean> {
    const session = this.driver.rxSession();

    const result$ = session
        .run(
            `
                RETURN exists( (:USER { _id: $id })-[:INTERACTIVE]->(:MOVIE) ) AS interacted
            `,
            {
              id: user._id.toString(),
            },
        )
        .records()
        .pipe(
            map(r => r.get('interacted') === true),
            first(
                identity,
                false,
            ),
        );

    return concat(
        result$,
        session.close() as Observable<never>,
    )
  }

  private findMoviesInIds({ ids, restById }: IdAndMap): Observable<MovieAndExtraInfo[]> {
    return defer(() => this.movieModel.find({ _id: { $in: ids } }))
        .pipe(
            map(movies =>
                movies.map(m =>
                    ({
                      ...m.toObject(),
                      ...(restById.get(m._id.toString()) ?? {}),
                    }),
                ),
            ),
        );
  }

  ///
  /// END RECOMMENDED
  ///

  searchMovies(userPayload: UserPayload, dto: SearchMoviesDto): Observable<MovieAndExtraInfo[]> {
    this.logger.debug(dto.category_ids);

    return defer(() =>
        dto.category_ids
            ? this.categoryModel.find({ _id: { $in: dto.category_ids } })
            : this.categoryModel.find({})
    ).pipe(
        exhaustMap(cats =>
            dto.category_ids ?
                (
                    cats.length != dto.category_ids.length
                        ? throwError(new BadRequestException(`Invalid category ids`))
                        : of(cats)
                )
                : of(cats),
        ),
        catchError(e =>
            e instanceof HttpException
                ? throwError(e)
                : throwError(new BadRequestException(e.message ?? 'Error'))
        ),
        tap(cats => this.logger.debug(`Cats.length: ${cats.length}`)),
        exhaustMap(cats => {
          dto.category_ids = cats.map(c => c._id.toString());
          const [query, parameters] = Neo4jService.buildQueryAndParams(checkCompletedLogin(userPayload), dto);
          this.logger.debug(dto);

          return this
              .getMovies(query, parameters)
              .pipe(map(movies => [...movies].sort((l, r) => r.recommendation - l.recommendation)));
        }),
    );
  }

  private static buildQueryAndParams(user: User, dto: SearchMoviesDto): [string, Record<string, any>] {
    // return [
    //   `
    //   MATCH (m: MOVIE)-[r1:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[r2:HAS_SHOW_TIME]-(t:THEATRE)
    //   WITH m,
    //           st,
    //           ('(?i).*' + $query + '.*') AS query
    //   WHERE (
    //             m.title =~ query
    //             OR m.overview =~ query
    //             OR st.room =~ query
    //             OR t.name =~ query
    //             OR t.address =~ query
    //           )
    //   RETURN m._id as _id, query
    //   `,
    //   {
    //     query: dto.query,
    //   }
    // ];

    const center = getCoordinates(dto);

    if (center) {
      return [
        `
          MATCH (m: MOVIE)-[r1:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[r2:HAS_SHOW_TIME]-(t:THEATRE), (m)-[r3:IN_CATEGORY]->(c:CATEGORY)
          WHERE c._id IN $cat_ids
          WITH m,
              st,
              datetime({ epochMillis: st.start_time }) AS startTime,
              datetime({ epochMillis: st.end_time }) AS endTime,
              datetime({epochMillis: m.released_date}) AS released_date,
              datetime($search_start_time) AS search_start_time,
              datetime($search_end_time) AS search_end_time,
              coalesce(distance(point({ latitude: $lat, longitude: $lng }), t.location), -1.0) AS distance,
              ('(?i).*' + $query + '.*') AS query,
              datetime($min_released_date) AS min_released_date,
              datetime($max_released_date) AS max_released_date
          WHERE (
                m.title =~ query
                OR m.overview =~ query
                OR st.room =~ query
                OR t.name =~ query
                OR t.address =~ query
              )
              AND $min_duration <= m.duration AND m.duration <= $max_duration
              AND m.age_type = $age_type
              AND 0 <= distance AND distance <= $max_distance
              AND min_released_date <= released_date AND released_date <= max_released_date
              AND search_start_time <= startTime AND endTime <= search_end_time
              AND m.is_active = true
           
          OPTIONAL MATCH (u: USER { _id: $uid })-[r:INTERACTIVE]->(m: MOVIE)
          WITH DISTINCT m, sum(r.score) AS recommendation, st
          RETURN m._id AS _id, recommendation
          ORDER BY recommendation DESC, st.start_time ASC
          LIMIT 100
         `,
        {
          search_start_time: dto.search_start_time.toISOString(),
          search_end_time: dto.search_end_time.toISOString(),
          lng: center[0],
          lat: center[1],
          query: dto.query,
          min_released_date: dto.min_released_date.toISOString(),
          max_released_date: dto.max_released_date.toISOString(),
          min_duration: dto.min_duration,
          max_duration: dto.max_duration,
          age_type: dto.age_type,
          max_distance: constants.maxDistanceInMeters,
          uid: user._id,
          cat_ids: dto.category_ids,
        },
      ];
    }

    return [
      `
          MATCH (m: MOVIE)-[r1:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[r2:HAS_SHOW_TIME]-(t:THEATRE), (m)-[r3:IN_CATEGORY]->(c:CATEGORY)
          WHERE c._id IN $cat_ids
          WITH m,
              st,
              datetime({ epochMillis: st.start_time }) AS startTime,
              datetime({ epochMillis: st.end_time }) AS endTime,
              datetime({epochMillis: m.released_date}) AS released_date,
              datetime($search_start_time) AS search_start_time,
              datetime($search_end_time) AS search_end_time,
              ('(?i).*' + $query + '.*') AS query,
              datetime($min_released_date) AS min_released_date,
              datetime($max_released_date) AS max_released_date
          WHERE (
                m.title =~ query
                OR m.overview =~ query
                OR st.room =~ query
                OR t.name =~ query
                OR t.address =~ query
              )
              AND $min_duration <= m.duration AND m.duration <= $max_duration
              AND m.age_type = $age_type
              AND min_released_date <= released_date AND released_date <= max_released_date
              AND search_start_time <= startTime AND endTime <= search_end_time
              AND m.is_active = TRUE
           
          OPTIONAL MATCH (u: USER { _id: $uid })-[r:INTERACTIVE]->(m: MOVIE)
          WITH DISTINCT m, sum(r.score) AS recommendation, st
          RETURN m._id AS _id, recommendation
          ORDER BY recommendation DESC, st.start_time ASC
          LIMIT 100
         `,
      {
        search_start_time: dto.search_start_time.toISOString(),
        search_end_time: dto.search_end_time.toISOString(),
        query: dto.query,
        min_released_date: dto.min_released_date.toISOString(),
        max_released_date: dto.max_released_date.toISOString(),
        min_duration: dto.min_duration,
        max_duration: dto.max_duration,
        age_type: dto.age_type,
        uid: user._id,
        cat_ids: dto.category_ids,
      },
    ];
  }

  getRelatedMovies(movieId: string) {
    return defer(() => this.movieModel.findById(movieId)).pipe(
        exhaustMap(movie => {
          if (!movie) {
            return throwError(new NotFoundException(`Not found movie with id ${movieId}`));
          }

          this.logger.debug(`getRelatedMovies ${movie.title}`);

          const query = `
              MATCH (m:MOVIE {_id: $id })-[:IN_CATEGORY|:DIRECTED|ACTED_IN]->(c)<-[:IN_CATEGORY|:DIRECTED|ACTED_IN]-(other:MOVIE)
              WITH m, other, count(c) AS intersection, collect(c._id) AS i
              
              MATCH (m)-[:IN_CATEGORY|:DIRECTED|ACTED_IN]->(mg)
              WITH m, other, intersection, i, collect(mg._id) AS s1
              
              MATCH (other)-[:IN_CATEGORY|:DIRECTED|ACTED_IN]->(og)
              WITH m, other, intersection, i, s1, collect(og._id) AS s2
              
              WITH m, other, intersection, s1, s2
              WITH m, other, intersection, s1+[x IN s2 WHERE NOT x IN s1] AS union, s1, s2
              
              RETURN other._id AS _id, ((1.0 * intersection) / size(union)) AS jaccard, s1, s2
              ORDER BY jaccard DESC
              LIMIT 16
          `;
          const parameters = {
            id: movieId,
          };

          return this
              .getMovies(query, parameters)
              .pipe(map(movies => [...movies].sort((l, r) => r.jaccard - l.jaccard)));
        }),
        catchError(e =>
            e instanceof HttpException
                ? throwError(e)
                : throwError(new BadRequestException(e.message ?? 'Error'))
        )
    );
  }

  private getMovies(query: string, parameters: Record<string, any>): Observable<MovieAndExtraInfo[]> {
    const session = this.driver.rxSession();

    return concat(
        session
            .run(query, parameters)
            .records()
            .pipe(
                map(record =>
                    ({
                      ...record.toObject(),
                      _id: record.get('_id') as string,
                    })
                ),
                toArray(),
                map(splitIdAndRests),
                exhaustMap(idAndMap => this.findMoviesInIds(idAndMap)),
            ),
        session.close() as Observable<never>,
    );
  }

  test(id: string) {
    const session = this.driver.rxSession();

    return concat(
        session
            .run(
                `
                    MATCH (u1:USER { _id: $id })-[r1:INTERACTIVE]->(m:MOVIE)
                    WITH u1, avg(r1.score) AS u1_mean
                    
                    MATCH (u1)-[r1:INTERACTIVE]->(m:MOVIE)<-[r2:INTERACTIVE]-(u2:USER)
                    WITH u1, u1_mean, u2, collect({ r1: r1, r2: r2 }) AS interactions
                    
                    MATCH (u2)-[r2:INTERACTIVE]->(m:MOVIE)
                    WITH u1, u1_mean, u2, avg(r2.score) AS u2_mean, interactions
                    
                    UNWIND interactions AS r
                    
                    WITH sum( (r.r1.score - u1_mean) * (r.r2.score - u2_mean) ) AS nom,
                         sqrt( sum((r.r1.score - u1_mean) ^ 2) * sum((r.r2.score - u2_mean) ^ 2) ) AS denom,
                         u1, u2 WHERE denom <> 0
                      
                    WITH u1, u2, nom / denom AS pearson
                    ORDER BY pearson DESC LIMIT 30
                    
                    MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE) WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
                    RETURN m, sum(pearson * r.score) AS recommendation, pearson, r.score AS score
                    ORDER BY recommendation DESC LIMIT 64
                  `,
                {
                  id
                }
            )
            .records()
            .pipe(
                map(record => record.toObject()),
                toArray(),
            ),
        session.close() as Observable<never>,
    );
  }
}

`

          OPTIONAL MATCH (u2)-[r:INTERACTIVE]->(m:MOVIE) WHERE NOT exists( (u1)-[:INTERACTIVE]->(m) )
          WITH m, pearson, r
          RETURN m._id AS _id, sum(pearson * r.score) AS recommendation, pearson, r.score AS score
          ORDER BY recommendation DESC LIMIT 24`;

`
          MATCH (m: MOVIE)-[r1:HAS_SHOW_TIME]->(st:SHOW_TIME)<-[r2:HAS_SHOW_TIME]-(t:THEATRE)
          WITH m,
              st,
              datetime({ epochMillis: st.start_time }) AS startTime,
              datetime({ epochMillis: st.end_time }) AS endTime,
              datetime($search_start_time) AS search_start_time,
              datetime($search_end_time) AS search_end_time,
              coalesce(distance(point({ latitude: $lat, longitude: $lng }), t.location), -1.0) AS distance,
              ('(?i).*' + $query + '.*') AS query,
              datetime($min_released_date) AS min_released_date,
              datetime($max_released_date) AS max_released_date
          WHERE $min_duration <= m.duration AND m.duration <= $max_duration
              AND m.age_type = $age_type
              AND min_released_date <= m.released_date AND m.released_date <= max_released_date
              AND 0 <= distance AND distance <= $max_distance
              AND search_start_time <= startTime AND endTime <= search_end_time
              AND (
                m.title =~ query
                OR m.overview =~ query
                OR st.room =~ query
                OR t.name =~ query
                OR t.address =~ query
              )
           
          OPTIONAL MATCH (u: USER { _id: $uid })-[r:INTERACTIVE]->(m: MOVIE)
          WITH DISTINCT m, sum(r.score) AS recommendation, st
          RETURN m._id AS _id, recommendation
          ORDER BY recommendation DESC, st.start_time ASC
          LIMIT 100
         `;

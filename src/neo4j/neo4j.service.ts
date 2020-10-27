import { Injectable, Logger } from '@nestjs/common';
import { auth, driver, Driver, Transaction } from 'neo4j-driver';
import { ConfigKey, ConfigService } from '../config/config.service';
import { DocumentDefinition, Model } from 'mongoose';
import { User } from '../users/user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from '../movies/movie.schema';
import { Category } from '../categories/category.schema';
import { Comment } from "../comments/comment.schema";

const FAVORITE_SCORE = 1;
const COMMENT_SCORE = (comment: DocumentDefinition<Comment>) => comment.rate_star;

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
  ) {
    try {
      this.driver = driver(
          configService.get(ConfigKey.NEO4J_URL),
          auth.basic(
              configService.get(ConfigKey.NEO4J_USER),
              configService.get(ConfigKey.NEO4J_PASSWORD),
          )
      );
      this.logger.debug(`Done ${this.driver}`);
    } catch (e) {
      this.logger.debug(`Error ${e}`);
    }
  }

  async transferData(): Promise<void> {
    await this.runTransaction(txc =>
            txc.run(`
              MATCH (n)
              DETACH DELETE n`
            ),
        '[DELETE]',
    );

    await this.addCategories();
    await this.addMovies();
    await this.addUsers();
    await this.addComments();
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
                    RETURN user.email as email
                `,
                {
                  _id: user._id.toString(),
                  uid: user.uid,
                  email: user.email ?? '',
                  full_name: user.full_name ?? '',
                  gender: user.gender ?? 'MALE',
                  address: user.address ?? '',
                  longitude: user.location?.coordinates?.[0] ?? -1,
                  latitude: user.location?.coordinates?.[1] ?? -1,
                }
            );
          }
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
      for (const mov of movies) {
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
    }, `[MOVIES] ${movies.length}`);

    await this.runTransaction(async txc => {
      for (const mov of movies) {
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
    }, `[MOVIES] ${movies.length}`);
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
    }).lean();

    await this.runTransaction(
        async txc => {
          for (const comment of comments) {
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
}

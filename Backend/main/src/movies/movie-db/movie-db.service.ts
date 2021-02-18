import { HttpService, Injectable, Logger } from '@nestjs/common';
import { ConfigKey, ConfigService } from '../../config/config.service';
import { catchError, concatMap, filter, ignoreElements, map, mapTo, mergeMap, tap, toArray } from 'rxjs/operators';
import { defer, EMPTY, from, Observable, zip } from 'rxjs';
import { Movie } from '../movie.schema';
import { CreateDocumentDefinition, Model } from 'mongoose';
import { Category } from '../../categories/category.schema';
import { MovieCategory } from '../movie-category.schema';
import { Person } from '../../people/person.schema';
import { fromArray } from 'rxjs/internal/observable/fromArray';
import { InjectModel } from '@nestjs/mongoose';
import * as fs from 'fs';
import { ShowTime } from "../../show-times/show-time.schema";
import { Theatre } from "../../theatres/theatre.schema";
import { Comment } from "../../comments/comment.schema";
import { Ticket } from "../../seats/ticket.schema";
import { Reservation } from "../../reservations/reservation.schema";
import { Notification } from "../../notifications/notification.schema";
import dayjs = require('dayjs');
import { User } from "../../users/user.schema";

@Injectable()
export class MovieDbService {
  private readonly logger = new Logger('MovieDbService');

  private readonly catDocByName = new Map<string, Category>();
  private readonly personByFullName = new Map<string, Person>();

  private readonly days = Array
      .from({ length: 7 * 32 }, (_, i) => i)
      .map(i => dayjs(new Date()).add(i - 7, 'day').toDate());
  private dayCount = 0;

  constructor(
      private readonly httpService: HttpService,
      private readonly configService: ConfigService,
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
      @InjectModel(Category.name) private readonly categoryModel: Model<Category>,
      @InjectModel(MovieCategory.name) private readonly movieCategoryModel: Model<MovieCategory>,
      @InjectModel(Person.name) private readonly personModel: Model<Person>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
      @InjectModel(Comment.name) private readonly commentModel: Model<Comment>,
      @InjectModel(Ticket.name) private readonly ticketModel: Model<Ticket>,
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Notification.name) private readonly notificationModel: Model<Notification>,
      @InjectModel(User.name) private readonly userModel: Model<User>,
  ) {
  }

  seed(query: string, page: number, year: number) {
    return this.search(query, page, year)
        .pipe(
            map(res => res.results),
            tap(results => this.logger.debug(`Search ${query} ${page} ${year} -> ${results.length} items`)),
            mergeMap(results => fromArray(results)),
            map(movie => movie.id),
            concatMap(id =>
                zip(this.detail(id), this.credits(id))
                    .pipe(
                        mergeMap(([detail, credits]) =>
                            this.saveMovieDetail(detail, credits)
                        )
                    )
            ),
            ignoreElements(),
            tap({ complete: () => this.logger.debug('Saved done') })
        );
  }

  private get apiKey() {
    return this.configService.get(ConfigKey.MOVIE_DB_API_KEY);
  }

  private search(query: string, page: number, year: number): Observable<SearchMovieResponseResult> {
    const url = `https://api.themoviedb.org/3/search/movie?api_key=${this.apiKey}&language=en-US&query=${query}&page=${page}&include_adult=false&year=${year}`;
    return this.httpService
        .get(url)
        .pipe(map(response => response.data as SearchMovieResponseResult));
  }

  private detail(movieId: number): Observable<MovieDetailResponseResult> {
    const url = `https://api.themoviedb.org/3/movie/${movieId}?api_key=${this.apiKey}&language=en-US&append_to_response=videos`;
    return this.httpService
        .get(url)
        .pipe(map(response => response.data as MovieDetailResponseResult));
  }

  private credits(movieId: number) {
    const url = `https://api.themoviedb.org/3/movie/${movieId}/credits?api_key=${this.apiKey}`;
    return this.httpService
        .get(url)
        .pipe(map(response => response.data as MovieCreditsResponseResult));
  }

  //
  //
  //

  private async getCategories(cats: Genre[]): Promise<Category[]> {
    const categories: Category[] = [];

    const catNames = cats.map(c => c.name);
    for (const name of catNames) {
      const cache = this.catDocByName.get(name);
      if (cache) {
        this.logger.debug(`Get category by '${name}' hits cache`);
        categories.push(cache);
        continue;
      }

      const found = await this.categoryModel.findOne({ name });
      if (!found) {
        throw Error(`Not found category by name: ${name}`);
      }
      this.logger.debug(`Get category by '${name}' found`);

      this.catDocByName.set(name, found);
      categories.push(found);
    }

    return categories;
  }

  private async getPeople(peopleRaw: { profile_path: string, name: string }[]) {
    const people: Person[] = [];

    for (const p of peopleRaw) {
      const cache = this.personByFullName.get(p.name);
      if (cache) {
        this.logger.debug(`Get person by '${p.name}' hits cache`);
        people.push(cache);
        continue;
      }

      const found = await this.personModel.findOne({ full_name: p.name });
      if (found) {
        this.logger.debug(`Get person by '${p.name}' found`);
        this.personByFullName.set(p.name, found);
        people.push(found);
        continue;
      }

      const personDoc: Omit<CreateDocumentDefinition<Person>, '_id'> = {
        avatar: 'http://image.tmdb.org/t/p/w185' + p.profile_path,
        full_name: p.name,
        is_active: true
      };
      const created = await this.personModel.create(personDoc);
      this.logger.debug(`Get person by '${p.name}' created ${JSON.stringify(created)}`);

      this.personByFullName.set(p.name, created);
      people.push(created);
    }

    return people;
  }

  private async saveMovieCategory(saved: Movie, categories: Category[]) {
    for (const category of categories) {
      const movieCategory: Partial<Pick<MovieCategory, keyof MovieCategory>> = {
        'category_id': category._id,
        'movie_id': saved._id,
      };
      await this.movieCategoryModel.findOneAndUpdate(
          movieCategory,
          movieCategory,
          { upsert: true }
      );
    }
  }

  private async saveMovieDetail(v: MovieDetailResponseResult, c: MovieCreditsResponseResult) {
    this.logger.debug('Start save movie detail');

    if (await this.movieModel.findOne({ title: v.title })) {
      this.logger.debug('End save movie detail [found]');
      return;
    }

    this.dayCount = (this.dayCount + 1) % this.days.length;

    const actors = await this.getPeople(c.cast.slice(0, 10));
    const directors = await this.getPeople(c.crew.filter(c => c.job === 'Director'));

    const videoKey = v.videos.results?.[0]?.key;
    const movieDoc: Omit<CreateDocumentDefinition<Movie>, '_id'> = {
      rate_star: 0,
      total_rate: 0,
      total_favorite: 0,
      age_type: 'P',
      title: v.title,
      trailer_video_url: videoKey ? `https://www.youtube.com/watch?v=${videoKey}` : null,
      poster_url: v.poster_path ? `https://image.tmdb.org/t/p/w342${v.poster_path}` : null,
      overview: v.overview,
      released_date: this.days[this.dayCount],
      duration: v.runtime ?? 100,
      directors: directors.map(d => d._id),
      actors: actors.map(d => d._id),
      is_active: true,
      original_language: v.original_language
    };
    const saved = await this.movieModel.create(movieDoc);

    const categories = await this.getCategories(v.genres);
    await this.saveMovieCategory(saved, categories);

    this.logger.debug('End save movie detail');
  };

  updateVideoUrl() {
    return defer(() =>
        this.movieModel
            .find({
              $or: [
                { trailer_video_url: { $exists: false } },
                { trailer_video_url: null },
                { trailer_video_url: '' },
              ]
            })
            .sort({ createdAt: -1 })
    )
        .pipe(
            tap(movies => this.logger.debug(`Start update video url ${movies.length}`)),
            mergeMap(movies => from(movies)),
            concatMap((movie, index) =>
                this.search(movie.title, 1, null)
                    .pipe(
                        map(searchResults => searchResults.results[0]?.id),
                        filter(id => !!id),
                        mergeMap(id => this.detail(id)),
                        mergeMap(async v => {
                          const videoKey = v.videos.results?.[0]?.key;
                          if (videoKey) {
                            movie.trailer_video_url = `https://www.youtube.com/watch?v=${videoKey}`;
                            await movie.save();
                            this.logger.debug(`Update ${index} ${movie._id} -> ${movie.trailer_video_url}`);
                          }
                        }),
                    )
            ),
            tap({ complete: () => this.logger.debug(`Done update video url`) }),
        );
  }

  removeAdultMovies() {
    const array: { detail: MovieDetailResponseResult, found: string | undefined }[] = [];

    return defer(() => this.movieModel.find({}).sort({ createdAt: -1 })).pipe(
        tap(a => this.logger.debug(`All ${a.length} movies`)),
        mergeMap(from),
        concatMap((movie: Movie, index: number): Observable<Movie> => {
          this.logger.debug(index);

          return this
              .search(movie.title, 1, null)
              .pipe(
                  map(searchResults => searchResults.results?.find(i => i.title === movie.title)?.id),
                  filter(id => !!id),
                  mergeMap(id => this.detail(id)),
                  filter(d => {
                    const removed = d.adult || (() => {
                      delete d.adult;
                      const s = JSON.stringify(d).toLowerCase();

                      const found = [
                        'sex',
                        'gay',
                        'adult',
                        'porn',
                        'sex',
                      ]
                          .find(v => s.includes(v.toLowerCase()));

                      array.push({
                        detail: d,
                        found,
                      });

                      return found;
                    })();
                    // this.logger.debug(`${index}-${movie.title}-${movie._id} is adult? ${removed}`);
                    return !!removed;
                  }),
                  mapTo(movie),
                  catchError(() => EMPTY),
              );
        }),
        toArray(),
        mergeMap(async movies => {
          this.logger.debug(array.length);

          await new Promise(((resolve, reject) => {
            fs.writeFile('./movie.json', JSON.stringify(array), {}, (e) => {
              if (e) reject(e)
              else resolve();
            });
          }));

          await this.deleteAllByMovieIds(movies.map(m => m._id));

          this.logger.debug(movies.length);
          return movies.length;
        }),
    )
  }

  private async deleteAllByMovieIds(ids: any[]) {
    const inIds = { $in: ids };
    await this.movieModel.deleteMany({ _id: inIds });
    await this.movieCategoryModel.deleteMany({ movie_id: inIds });
    await this.commentModel.deleteMany({ movie: inIds })

    const st = await this.showTimeModel.find({ movie: inIds });
    const relSt = { show_time: { $in: st.map(s => s._id) } };

    await this.showTimeModel.deleteMany({ movie: inIds });
    await this.ticketModel.deleteMany(relSt);

    const reservations = await this.reservationModel.find(relSt);
    await this.reservationModel.deleteMany(relSt);
    await this.notificationModel.deleteMany({ reservation: { $in: reservations.map(r => r._id) } });

    const users = await this.userModel.find({});
    for (const user of users) {
      const favorite_movie_ids = user.favorite_movie_ids ?? {};
      let changed = false;

      for (const movieId of ids) {
        if (favorite_movie_ids[movieId]) {
          delete favorite_movie_ids[movieId];
          changed = true;
        }
      }
      if (changed) {
        await this.userModel.updateOne({ _id: user._id }, { favorite_movie_ids });
      }
    }
  }

  async removeMovies() {
    const $in = [
      'Love Shots',
      'Proof Of Love',
      'RDX Love',
      "A Brother's Love",
      'Love Blooms',
      'swiping compressed filtered love (et enfin, permettre l’incontrôlable)',
      'The Only Thing I Love More Than You Is Ranch Dressing',
      'If You Know Me Is To Love Me',
      'Bears Love Me!',
      'Muffin Top: A Love Story',
      'Ovid and the Art of Love',
      'Do You Love Your Mom and Her Two-Hit Multi-Target Attacks? OVA',
      'Loveless',
      'Love to Our Fathers’ Sacred Graves. Echo of Port Arthur',
      'I love Everything I Hate About You',
      'The Killing of Two Lovers',
      'Why Do You Love Me?',
      'My Wife\'s Lover 3',
      'Doggy Love',
      'A Brother’s Love',
      'Love Without Size',
      'Love and Lies',
      'I Love You I Miss You I Hope I See You Before I Die',
      'Like Love',
      'Marianne & Leonard: Words of Love',
      'Almost Love',
      'A Secret Love',
      'Victim of Love',
      'Love, Loss, and What I Wore',
      'With Love – Volume One 1987-1996',
      'Love Mooning',
      'Love Aaj Kal',
      'Love Aaj Kal Porshu',
      'Joy House',
      'All Things Fair',
      'Aqours 5th LoveLive! ～Next SPARKLING!!～',
      'Mektoub, My Love: Canto Uno',
      'Love Me Not',
      'Mektoub, My Love: Intermezzo',
    ];
    this.logger.debug(`Start ${$in.length}`);
    const movies = await this.movieModel.find({
      title: { $in }
    });
    this.logger.debug(`Movies ${movies.length}`);
    await this.deleteAllByMovieIds(movies.map(m => m._id));
    this.logger.debug('Done');
  }

  async removeDup() {
    const ms = await this.movieModel.find({});
    let i = 0;
    for (const m of ms) {
      const dups = await this.movieModel.find({ title: m.title, _id: { $ne: m._id } });
      if (dups.length > 0) {
        this.logger.debug(`${m.title} dup ${dups.length}`);
        await this.deleteAllByMovieIds(dups.map(d => d._id));
      }
      this.logger.debug(`${i++}/${ms.length}`);
    }
  }

  async removeShort() {
    const ms = await this.movieModel.find({ duration: { $lt: 30 } });
    let i = 0;
    for (const m of ms) {
      await this.deleteAllByMovieIds([m._id]);
      this.logger.debug(`${i++}/${ms.length}`);
    }
  }
}

//
// SEARCH
//

export interface SearchMovieResponseResult {
  page: number;
  total_results: number;
  total_pages: number;
  results: SearchMovie[];
}

export interface SearchMovie {
  popularity: number;
  vote_count: number;
  video: boolean;
  poster_path: null | string;
  id: number;
  adult: boolean;
  backdrop_path: null | string;
  original_language: string;
  original_title: string;
  genre_ids: number[];
  title: string;
  vote_average: number;
  overview: string;
  release_date: string;
}

//
// DETAIL
//

export interface MovieDetailResponseResult {
  adult: boolean;
  backdrop_path: string;
  belongs_to_collection: null;
  budget: number;
  genres: Genre[];
  homepage: string;
  id: number;
  imdb_id: string;
  original_language: string;
  original_title: string;
  overview: string;
  popularity: number;
  poster_path: string;
  production_companies: ProductionCompany[];
  production_countries: ProductionCountry[];
  release_date: string;
  revenue: number;
  runtime: number;
  spoken_languages: SpokenLanguage[];
  status: string;
  tagline: string;
  title: string;
  video: boolean;
  vote_average: number;
  vote_count: number;
  videos: Videos;
}

export interface Videos {
  results: VideoResult[];
}

export interface VideoResult {
  id: string;
  iso_639_1: string;
  iso_3166_1: string;
  key: string;
  name: string;
  site: string;
  size: number;
  type: string;
}

export interface Genre {
  id: number;
  name: string;
}

export interface ProductionCompany {
  id: number;
  logo_path: null | string;
  name: string;
  origin_country: string;
}

export interface ProductionCountry {
  iso_3166_1: string;
  name: string;
}

export interface SpokenLanguage {
  iso_639_1: string;
  name: string;
}

//
// CREDITS
//

export interface MovieCreditsResponseResult {
  id: number;
  cast: Cast[];
  crew: Crew[];
}

export interface Cast {
  cast_id: number;
  character: string;
  credit_id: string;
  gender: number;
  id: number;
  name: string;
  order: number;
  profile_path: null | string;
}

export interface Crew {
  credit_id: string;
  department: string;
  gender: number;
  id: number;
  job: string;
  name: string;
  profile_path: null | string;
}

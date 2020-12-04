import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from './movie.schema';
import { CreateDocumentDefinition, Model } from 'mongoose';
import { ShowTime } from '../show-times/show-time.schema';
import * as dayjs from 'dayjs';
import { Theatre } from '../theatres/theatre.schema';
import { constants, getSkipLimit } from '../common/utils';
import { PaginationDto } from '../common/pagination.dto';
import { Category } from '../categories/category.schema';
import { AddMovieDto } from './movie.dto';
import { MovieCategory } from './movie-category.schema';
import { Person } from '../people/person.schema';

@Injectable()
export class MoviesService {
  private readonly logger = new Logger('MoviesService');

  constructor(
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
      @InjectModel(Category.name) private readonly categoryModel: Model<Category>,
      @InjectModel(MovieCategory.name) private readonly movieCategoryModel: Model<MovieCategory>,
      @InjectModel(Person.name) private readonly personModel: Model<Person>,
  ) {}

  async getAll(dto: PaginationDto): Promise<Movie[]> {
    const { skip, limit } = getSkipLimit(dto);

    const movies: (Movie & { categories: { category_id: Category }[] })[] = (
        await this.movieModel
            .find({})
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit)
            .populate({
              path: 'categories',
              populate: { path: 'category_id' },
            })
            .populate('actors')
            .populate('directors')
    ).map(m => m.toJSON()) as any;

    return movies.map(m => {
      return {
        ...m,
        categories: m.categories.map(c => c.category_id),
      } as any;
    });
  }

  getNowShowingMovies(center: [number, number] | null, paginationDto: PaginationDto): Promise<Movie[]> {
    const currentDay = new Date();

    const start = dayjs(currentDay).startOf('day').toDate();
    const end = dayjs(currentDay).endOf('day').add(4, 'day').toDate();

    const skipLimit = getSkipLimit(paginationDto);

    this.logger.debug(`getNowShowingMovies: ${currentDay} -- ${start} -- ${end} -- ${center}`);

    return this.theatreModel.aggregate([
      ...(
          center != null
              ?
              [
                {
                  $geoNear: {
                    near: {
                      type: 'Point',
                      coordinates: center,
                    },
                    distanceField: 'distance',
                    includeLocs: 'location',
                    maxDistance: constants.maxDistanceInMeters,
                    spherical: true,
                  },
                },
                { $match: { is_active: true } }
              ]
              : []
      ),
      {
        $lookup: {
          from: 'show_times',
          localField: '_id',
          foreignField: 'theatre',
          as: 'show_time',
        }
      },
      { $unwind: '$show_time' },
      {
        $match: {
          $and: [
            { 'show_time.start_time': { $gte: start } },
            { 'show_time.end_time': { $lte: end } },
            { 'show_time.is_active': true },
          ]
        },
      },
      {
        $sort: {
          'show_time.start_time': 1
        }
      },
      {
        $lookup: {
          from: 'movies',
          localField: 'show_time.movie',
          foreignField: '_id',
          as: 'movie',
        }
      },
      { $unwind: '$movie' },
      {
        $match: {
          'movie.released_date': { $lte: start },
        },
      },
      {
        $group: {
          _id: '$movie._id',
          data: { $first: '$movie' },
        }
      },
      {
        $unwind: '$data'
      },
      {
        $skip: skipLimit.skip,
      },
      {
        $limit: skipLimit.limit
      },
      {
        $replaceRoot: {
          newRoot: '$data'
        }
      }
    ]).exec();
  }

  getComingSoonMovies(paginationDto: PaginationDto): Promise<Movie[]> {
    const currentDay = new Date();
    const startOfTomorrow = dayjs(currentDay).startOf('day').add(1, 'day').toDate();

    const skipLimit = getSkipLimit(paginationDto);

    this.logger.debug(`getComingSoonMovies: ${currentDay} -- ${startOfTomorrow}`);

    return this.movieModel.aggregate([
      {
        $match: {
          released_date: {
            $gte: startOfTomorrow,
          }
        },
      },
      {
        $lookup: {
          from: 'show_times',
          localField: '_id',
          foreignField: 'movie',
          as: 'show_times',
        },
      },
      {
        $match: {
          'show_times.0': {
            $exists: false
          }
        }
      },
      {
        $sort: {
          released_date: 1,
        }
      },
      {
        $skip: skipLimit.skip,
      },
      {
        $limit: skipLimit.limit
      },
    ]).exec();
  }

  async getDetail(id: string): Promise<Movie> {
    const movie: (Movie & { categories: { category_id: Category }[] }) | null = (await this.movieModel
        .findOne({ _id: id })
        .populate('actors')
        .populate('directors')
        .populate({
          path: 'categories',
          populate: { path: 'category_id' },
        })
        .exec())?.toJSON() as any;

    if (movie == null) {
      throw new NotFoundException(`Movie with id: ${id} not found`);
    }

    (movie as any).categories = movie.categories.map(c => c.category_id);
    return movie;
  }

  async getMostFavorite(paginationDto: PaginationDto): Promise<Movie[]> {
    const { skip, limit } = getSkipLimit(paginationDto);
    return this.movieModel
        .find({})
        .sort({ total_favorite: -1, rate_star: -1 })
        .skip(skip)
        .limit(limit)
  }

  async getMostRate(paginationDto: PaginationDto): Promise<Movie[]> {
    const { skip, limit } = getSkipLimit(paginationDto);
    return this.movieModel
        .find({})
        .sort({ rate_star: -1, total_favorite: -1 })
        .skip(skip)
        .limit(limit);
  }

  async addMovie(dto: AddMovieDto): Promise<Movie> {
    const [actors, directors, categories] = await Promise.all([
      this.personModel.find({ _id: { $in: dto.actor_ids } }, { _id: 1 }),
      this.personModel.find({ _id: { $in: dto.director_ids } }, { _id: 1 }),
      this.categoryModel.find({ _id: { $in: dto.category_ids } }, { _id: 1 }),
    ]);

    const doc: Omit<CreateDocumentDefinition<Movie>, '_id'> = {
      actors: actors.map(p => p._id),
      age_type: dto.age_type,
      directors: directors.map(p => p._id),
      duration: dto.duration,
      is_active: true,
      original_language: dto.original_language,
      overview: dto.overview,
      poster_url: dto.poster_url,
      rate_star: 0,
      released_date: dto.released_date,
      title: dto.title,
      total_favorite: 0,
      total_rate: 0,
      trailer_video_url: dto.trailer_video_url,
    };
    const created = await this.movieModel.create(doc);

    await this.movieCategoryModel.create(
        categories.map(cat => {
          const doc: Omit<CreateDocumentDefinition<MovieCategory>, '_id'> = {
            category_id: cat._id,
            movie_id: created._id,
          };
          return doc;
        }),
    );

    return created;
  }

  searchByTitle(title: string): Promise<Movie[]> {
    return this.movieModel
        .find({
          title: {
            $regex: title,
            $options: 'i',
          }
        })
        .exec();
  }
}

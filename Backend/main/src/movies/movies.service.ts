import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from './movie.schema';
import { Model } from 'mongoose';
import { ShowTime } from '../show-times/show-time.schema';
import * as dayjs from 'dayjs';
import { Theatre } from '../theatres/theatre.schema';

@Injectable()
export class MoviesService {
  private readonly logger = new Logger('MoviesService');

  constructor(
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
  ) {}

  all() {
    return this.movieModel
        .find({})
        .populate('actors')
        .populate('directors')
        .exec();
  }

  getNowShowingMovies(center: [number, number]) {
    const currentDay = new Date();

    const start = dayjs(currentDay).startOf('day').toDate();
    const end = dayjs(currentDay).endOf('day').add(7, 'day').toDate();
    const maxDistanceInMeters = 30_000;

    this.logger.debug(`getNowShowingMovies: ${currentDay} -- ${start} -- ${end} -- ${center}`);

    return this.theatreModel.aggregate([
      {
        $geoNear: {
          near: {
            type: 'Point',
            coordinates: center,
          },
          distanceField: 'distance',
          includeLocs: 'location',
          maxDistance: maxDistanceInMeters,
          spherical: true,
        },
      },
      { $match: { is_active: true } },
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
        $replaceRoot: {
          newRoot: '$data'
        }
      }
    ]).exec();
  }
}

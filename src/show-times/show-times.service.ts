import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ShowTime } from './show-time.schema';
import * as mongoose from 'mongoose';
import { CreateDocumentDefinition, Model } from 'mongoose';
import { Movie } from '../movies/movie.schema';
import { Theatre } from '../theatres/theatre.schema';
import * as dayjs from 'dayjs';
import { from } from 'rxjs';
import { filter, pairwise, take } from 'rxjs/operators';
import { constants } from '../common/utils';

// eslint-disable-next-line
const isBetween = require('dayjs/plugin/isBetween');
dayjs.extend(isBetween);

@Injectable()
export class ShowTimesService {
  private readonly logger = new Logger('ShowTimesService');
  private movieCount: number | null = null;

  constructor(
      @InjectModel(ShowTime.name) private readonly  showTimeModel: Model<ShowTime>,
      @InjectModel(Movie.name) private readonly  movieModel: Model<Movie>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
  ) {}

  async seed() {
    const current = dayjs(new Date());
    const theatres = await this.theatreModel.find({});

    for (const theatre of theatres) {

      const [startHString, endHString] = theatre.opening_hours.split(' - ');

      let startH = +startHString.split(':')[0];
      const startM = +startHString.split(':')[1];
      if (startM > 0) {
        ++startH;
      }
      const [endH, endM] = endHString.split(':').map(x => +x);

      const hours: number[] = Array.from({ length: endH - startH + 1 }, (_, i) => i + startH);
      this.logger.debug(`Hours for ${theatre.name} are ${JSON.stringify(hours)} -- ${startH}:${startM} -> ${endH}:${endM}`);

      for (const room of theatre.rooms) {
        for (let dDate = -1; dDate <= 10; dDate++) {
          const day = current.startOf('day').add(dDate, 'day');

          const thStartTime = day.set('hour', startH).set('minute', startM);
          const thEndTime = day.set('hour', endH).set('minute', endM);

          const movie = await this.randomMovie();

          for (const hour of hours) {
            await this.checkAndSave(day, hour, movie, theatre, room, thStartTime, thEndTime);
          }
        }
      }
    }
  }

  private async checkAndSave(
      day: dayjs.Dayjs,
      hour: number,
      movie: Movie,
      theatre: Theatre,
      room: string,
      thStartTime: dayjs.Dayjs,
      thEndTime: dayjs.Dayjs
  ) {
    const startTime = day
        .set('hour', hour)
        .set('minute', 0)
        .set('second', 0)
        .set('millisecond', 0);
    const endTime = startTime.add(movie.duration, 'minute');

    this.logger.debug(`Start saving show time: ${theatre.name} -- ${room} <> ${thStartTime.toDate()}-${thEndTime.toDate()} <> ${startTime}-${endTime}`);

    const showTimes = await this.showTimeModel
        .find({
          theatre: theatre._id,
          room,
          is_active: true,
          start_time: { $gte: thStartTime.toDate() },
          end_time: { $lte: thEndTime.toDate() },
        })
        .sort({ start_time: 'asc' });

    if (showTimes.length == 1) {
      if (startTime.isBefore(showTimes[0].end_time) && endTime.isAfter(showTimes[0].start_time)
          || startTime.isBefore(thStartTime) || endTime.isAfter(thEndTime)) {
        return;
      }
    }

    if (showTimes.length >= 2) {
      const array = await from(showTimes)
          .pipe(
              pairwise(),
              filter(([prev, next]) =>
                  (startTime as any).isBetween(prev.end_time, next.start_time)
                  && (endTime as any).isBetween(prev.end_time, next.start_time)
                  && (startTime as any).isBetween(thStartTime, thEndTime)
                  && (endTime as any).isBetween(thStartTime, thEndTime)
              ),
              take(1),
          )
          .toPromise();

      if (array === undefined) {
        return;
      }

      this.logger.debug(`>>> Array ${array}`);
    }

    const doc: Omit<CreateDocumentDefinition<ShowTime>, '_id'> = {
      movie: movie._id,
      theatre: theatre._id,
      room,
      is_active: true,
      end_time: endTime.toDate(),
      start_time: startTime.toDate(),
    };
    const showTime = await this.showTimeModel.create(doc);

    this.logger.debug(`Saved show time: ${JSON.stringify(showTime)}`);
  }

  private async randomMovie() {
    const count = this.movieCount = this.movieCount ?? await this.movieModel.count({});
    const skip = Math.floor(count * Math.random());

    return await this.movieModel.findOne().skip(skip).exec();
  }

  getShowTimesByMovieId(movieId: string, center: [number, number] | null): Promise<{
    theatre: Theatre;
    show_time: ShowTime
  }[]> {
    const currentDay = new Date();

    const start = dayjs(currentDay).startOf('day').toDate();
    const end = dayjs(currentDay).endOf('day').add(4, 'day').toDate();

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
        $addFields: {
          theatre: '$$ROOT',
        },
      },
      {
        $project: {
          theatre: 1,
        }
      },
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
            { 'show_time.movie': new mongoose.Types.ObjectId(movieId) },
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
      { $project: { movie: 0 } },
    ]).exec();
  }
}

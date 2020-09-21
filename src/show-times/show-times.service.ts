import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ShowTime } from './show-time.schema';
import { Model } from 'mongoose';
import { Movie } from '../movies/movie.schema';
import { Theatre } from '../theatres/theatre.schema';
import * as dayjs from 'dayjs';
import { from } from 'rxjs';
import { filter, pairwise, take } from 'rxjs/operators';

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
    if (await this.showTimeModel.estimatedDocumentCount().exec() > 100) {
      return 'Nice';
    }

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
      this.logger.debug(`Hours for ${theatre.name} are ${JSON.stringify(hours)}`);

      for (const room of theatre.rooms) {
        for (let dDate = -10; dDate <= 20; dDate++) {
          const day = current.add(dDate, 'day');
          const thStartTime = day.set('hour', startH)
              .set('minute', startM)
              .set('second', 0)
              .set('millisecond', 0);
          const thEndTime = day.set('hour', endH)
              .set('minute', endM)
              .set('second', 0)
              .set('millisecond', 0);

          const movie = await this.randomMovie();

          for (const hour of hours) {
            const startTime = day
                .set('hour', hour)
                .set('minute', 0)
                .set('second', 0)
                .set('millisecond', 0);
            const endTime = startTime.add(movie.duration, 'minute');

            const showTimes = await this.showTimeModel
                .find({
                  theatre: theatre._id,
                  room,
                  is_active: true,
                })
                .sort({ start_time: 'asc' });

            if (showTimes.length == 1) {
              if (startTime.isBefore(showTimes[0].end_time) && endTime.isAfter(showTimes[0].start_time)
                  || startTime.isBefore(thStartTime) || endTime.isAfter(thEndTime)) {
                continue;
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
                continue;
              }

              this.logger.debug(`>>> Array ${array}`);
            }

            const showTime = await this.showTimeModel.create({
              movie: movie._id,
              theatre: theatre._id,
              room,
              is_active: true,
              end_time: endTime.toDate(),
              start_time: startTime.toDate(),
            });

            this.logger.debug(`Saved show time: ${JSON.stringify(showTime)}`);
          }
        }
      }
    }
  }

  private async randomMovie() {
    const count = this.movieCount = this.movieCount ?? await this.movieModel.count({});
    const skip = Math.floor(count * Math.random());

    return await this.movieModel.findOne().skip(skip).exec();
  }
}

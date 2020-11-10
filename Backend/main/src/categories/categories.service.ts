import { HttpService, Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Category } from './category.schema';
import { Model } from 'mongoose';
import { concatMap, filter, map, mergeMap, tap, toArray } from 'rxjs/operators';
import { fromArray } from 'rxjs/internal/observable/fromArray';
import { defer, Observable } from 'rxjs';
import { ConfigKey, ConfigService } from '../config/config.service';

@Injectable()
export class CategoriesService {
  private readonly logger = new Logger('CategoriesService');

  constructor(
      @InjectModel(Category.name) private readonly  categoryMode: Model<Category>,
      private readonly httpService: HttpService,
      private readonly configService: ConfigService,
  ) {}

  seed(): Observable<Category[]> {
    return defer(() => this.categoryMode.estimatedDocumentCount())
        .pipe(
            tap(count => this.logger.debug(`Count ${count}`)),
            filter(count => count == 0),
            mergeMap(() =>
                this.httpService
                    .get(`https://api.themoviedb.org/3/genre/movie/list?api_key=${this.configService.get(ConfigKey.MOVIE_DB_API_KEY)}`)
                    .pipe(
                        map(response => (response.data as { genres: { id: number, name: string }[] }).genres),
                        tap(cats => this.logger.debug(`GET ${JSON.stringify(cats)}`)),
                        mergeMap(cats => fromArray(cats)),
                        concatMap(({ name }) => new this.categoryMode({ name }).save()),
                        toArray(),
                        tap(cats => this.logger.debug(`Saved ${JSON.stringify(cats)}`)),
                    ),
            ),
        );
  }

  getAll(): Promise<Category[]> {
    return this.categoryMode.find({})
        .sort({ name: 1 })
        .exec();
  }
}

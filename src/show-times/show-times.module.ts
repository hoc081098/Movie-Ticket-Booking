import { Module } from '@nestjs/common';
import { ShowTimesController } from './show-times.controller';
import { ShowTimesService } from './show-times.service';
import { MongooseModule } from '@nestjs/mongoose';
import { ShowTime, ShowTimeSchema } from './show-time.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';
import { Movie, MovieSchema } from '../movies/movie.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: ShowTime.name,
        schema: ShowTimeSchema,
      },
      {
        name: Theatre.name,
        schema: TheatreSchema,
      },
      {
        name: Movie.name,
        schema: MovieSchema,
      },
    ]),
  ],
  controllers: [ShowTimesController],
  providers: [ShowTimesService]
})
export class ShowTimesModule {}

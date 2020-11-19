import { Module } from '@nestjs/common';
import { AdminShowTimesController, ShowTimesController } from './show-times.controller';
import { ShowTimesService } from './show-times.service';
import { MongooseModule } from '@nestjs/mongoose';
import { ShowTime, ShowTimeSchema } from './show-time.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';
import { Movie, MovieSchema } from '../movies/movie.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';

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
    AuthModule,
    UsersModule,
    ConfigModule,
  ],
  controllers: [ShowTimesController, AdminShowTimesController],
  providers: [ShowTimesService]
})
export class ShowTimesModule {}

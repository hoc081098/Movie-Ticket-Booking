import { HttpModule, Module } from '@nestjs/common';
import { MoviesService } from './movies.service';
import { AdminMoviesController, MoviesController } from './movies.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Movie, MovieSchema } from './movie.schema';
import { MovieCategory, MovieCategorySchema } from './movie-category.schema';
import { MovieDbService } from './movie-db/movie-db.service';
import { ConfigModule } from '../config/config.module';
import { Category, CategorySchema } from '../categories/category.schema';
import { Person, PersonSchema } from '../people/person.schema';
import { ShowTime, ShowTimeSchema } from '../show-times/show-time.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Movie.name,
        schema: MovieSchema,
      },
      {
        name: MovieCategory.name,
        schema: MovieCategorySchema,
      },
      {
        name: Category.name,
        schema: CategorySchema,
      },
      {
        name: Person.name,
        schema: PersonSchema,
      },
      {
        name: ShowTime.name,
        schema: ShowTimeSchema,
      },
      {
        name: Theatre.name,
        schema: TheatreSchema,
      }
    ]),
    HttpModule,
    ConfigModule,
    AuthModule,
    UsersModule,
    ConfigModule,
  ],
  providers: [MoviesService, MovieDbService],
  controllers: [MoviesController, AdminMoviesController],
  exports: [MoviesService],
})
export class MoviesModule {}

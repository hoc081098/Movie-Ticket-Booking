import { HttpModule, Module } from '@nestjs/common';
import { MoviesService } from './movies.service';
import { MoviesController } from './movies.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Movie, MovieSchema } from './movie.schema';
import { MovieCategory, MovieCategorySchema } from './movie-category.schema';
import { MovieDbService } from './movie-db/movie-db.service';
import { ConfigModule } from '../config/config.module';
import { Category, CategorySchema } from '../categories/category.schema';
import { Person, PersonSchema } from '../people/person.schema';

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
      }
    ]),
    HttpModule,
    ConfigModule,
  ],
  providers: [MoviesService, MovieDbService],
  controllers: [MoviesController]
})
export class MoviesModule {}

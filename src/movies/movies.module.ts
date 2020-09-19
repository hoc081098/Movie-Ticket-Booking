import { Module } from '@nestjs/common';
import { MoviesService } from './movies.service';
import { MoviesController } from './movies.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Movie, MovieSchema } from './movie.schema';
import { MovieCategory, MovieCategorySchema } from './movie-category.schema';

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
      }
    ]),
  ],
  providers: [MoviesService],
  controllers: [MoviesController]
})
export class MoviesModule {}

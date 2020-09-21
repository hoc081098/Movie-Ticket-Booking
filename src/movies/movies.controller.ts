import { Body, Controller, Get, Post } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';

@Controller('movies')
export class MoviesController {
  constructor(
      private readonly movieDbService: MovieDbService,
      private readonly moviesService: MoviesService,
  ) {}

  @Post('seed')
  seed(@Body() { query, page, year }: { query: string, page: number, year: number }) {
    return this.movieDbService.seed(query, page, year);
  }

  @Get('all')
  all() {
    return this.moviesService.all();
  }

  getNowShowingMovies() {
    return this.moviesService.getNowShowingMovies();
  }
}

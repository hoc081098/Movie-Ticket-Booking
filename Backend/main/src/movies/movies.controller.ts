import { Body, Controller, DefaultValuePipe, Get, ParseIntPipe, Post, Query } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';
import { Movie } from './movie.schema';
import { constants } from '../utils';

// @UseGuards(AuthGuard)
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

  @Get('now-playing')
  async getNowShowingMovies(
      @Query('page', new DefaultValuePipe(constants.defaultPage), ParseIntPipe) page: number,
      @Query('per_page', new DefaultValuePipe(constants.defaultPerPage), ParseIntPipe) perPage: number,
      @Query('lat') lat?: number,
      @Query('lng') lng?: number,
  ): Promise<Movie[]> {
    lat = parseFloat(lat as any);
    lng = parseFloat(lng as any);

    if (isNaN(lat) || isNaN(lng)) {
      return this.moviesService.getNowShowingMovies(null, page, perPage);
    }

    return this.moviesService.getNowShowingMovies([lng, lat], page, perPage);
  }

  @Get('coming-soon')
  async getComingSoonMovies(
      @Query('page', new DefaultValuePipe(constants.defaultPage), ParseIntPipe) page: number,
      @Query('per_page', new DefaultValuePipe(constants.defaultPerPage), ParseIntPipe) perPage: number,
  ) {
    return this.moviesService.getComingSoonMovies(page, perPage);
  }
}

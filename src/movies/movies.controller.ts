import { BadRequestException, Body, Controller, Get, Post, Query } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';

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
      @Query('lat') lat: number,
      @Query('lng') lng: number,
  ) {
    if (!lat || !lng) {
      throw new BadRequestException('Required lat and lng');
    }
    return this.moviesService.getNowShowingMovies([lng, lat]);
  }
}

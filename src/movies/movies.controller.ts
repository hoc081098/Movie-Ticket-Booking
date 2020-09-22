import {
  BadRequestException,
  Body,
  Controller,
  DefaultValuePipe,
  Get,
  ParseIntPipe,
  Post,
  Query
} from '@nestjs/common';
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
      @Query('lat') lat: number,
      @Query('lng') lng: number,
      @Query('page', new DefaultValuePipe(constants.defaultPage), ParseIntPipe) page: number,
      @Query('per_page', new DefaultValuePipe(constants.defaultPerPage), ParseIntPipe) perPage: number,
  ): Promise<Movie[]> {
    if (!lat || !lng) {
      throw new BadRequestException('Required lat and lng');
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

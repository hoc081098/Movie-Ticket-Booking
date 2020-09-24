import { Body, Controller, DefaultValuePipe, Get, Logger, ParseIntPipe, Post, Query, UseGuards } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';
import { Movie } from './movie.schema';
import { constants } from '../utils';
import { AuthGuard } from '../auth/auth.guard';

@UseGuards(AuthGuard)
@Controller('movies')
export class MoviesController {
  private readonly logger = new Logger('MoviesController');

  constructor(
      private readonly movieDbService: MovieDbService,
      private readonly moviesService: MoviesService,
  ) { }

  @Post('seed')
  seed(@Body() { query, page, year }: { query: string, page: number, year: number }) {
    return this.movieDbService.seed(query, page, year);
  }

  @Post('update-video-url')
  updateVideoUrl() {
    return this.movieDbService.updateVideoUrl();
  }

  @Get('now-playing')
  async getNowShowingMovies(
      @Query('page', new DefaultValuePipe(constants.defaultPage), ParseIntPipe) page: number,
      @Query('per_page', new DefaultValuePipe(constants.defaultPerPage), ParseIntPipe) perPage: number,
      @Query('lat') latS?: string,
      @Query('lng') lngS?: string,
  ): Promise<Movie[]> {
    this.logger.debug(`getNowShowingMovies [1]: '${latS}', '${lngS}'`);
    if (!latS || !lngS) {
      return this.moviesService.getNowShowingMovies(null, page, perPage);
    }

    const lat = parseFloat(latS);
    const lng = parseFloat(lngS);

    this.logger.debug(`getNowShowingMovies [1]: ${lat}, ${lng} ${isNaN(lat) || isNaN(lng)}`);
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

import { Body, Controller, DefaultValuePipe, Get, Logger, Param, ParseIntPipe, Post, Query } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';
import { Movie } from './movie.schema';
import { constants, getCoordinates } from '../utils';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('movies')
// @UseGuards(AuthGuard)
@Controller('movies')
export class MoviesController {
  private readonly logger = new Logger('MoviesController');

  constructor(
      private readonly movieDbService: MovieDbService,
      private readonly moviesService: MoviesService,
  ) { }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed(@Body() { query, page, year }: { query: string, page: number, year: number }) {
    return this.movieDbService.seed(query, page, year);
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('update-video-url')
  updateVideoUrl() {
    return this.movieDbService.updateVideoUrl();
  }

  @Get('now-playing')
  async getNowShowingMovies(
      @Query('page', new DefaultValuePipe(constants.defaultPage), ParseIntPipe) page: number,
      @Query('per_page', new DefaultValuePipe(constants.defaultPerPage), ParseIntPipe) perPage: number,
      @Query('lat') lat?: string,
      @Query('lng') lng?: string,
  ): Promise<Movie[]> {
    this.logger.debug(`getNowShowingMovies: '${lat}', '${lng}'`);
    return this.moviesService.getNowShowingMovies(
        getCoordinates({ lat, lng }),
        page,
        perPage
    );
  }

  @Get('coming-soon')
  async getComingSoonMovies(
      @Query('page', new DefaultValuePipe(constants.defaultPage), ParseIntPipe) page: number,
      @Query('per_page', new DefaultValuePipe(constants.defaultPerPage), ParseIntPipe) perPage: number,
  ) {
    return this.moviesService.getComingSoonMovies(page, perPage);
  }

  @Get(':id')
  getDetail(
      @Param('id') id: string,
  ): Promise<Movie | null> {
    return this.moviesService.getDetail(id)
  }
}

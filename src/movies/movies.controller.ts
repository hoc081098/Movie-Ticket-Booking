import { Body, Controller, Get, Logger, Param, Post, Query, UseGuards } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';
import { Movie } from './movie.schema';
import { getCoordinates } from '../common/utils';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { PaginationDto } from '../common/pagination.dto';
import { GetNowShowingMoviesDto } from './movie.dto';
import { AuthGuard } from '../auth/auth.guard';

@ApiTags('movies')
@UseGuards(AuthGuard)
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
      @Query() dto: GetNowShowingMoviesDto,
  ): Promise<Movie[]> {
    return this.moviesService.getNowShowingMovies(
        getCoordinates(dto),
        dto,
    );
  }

  @Get('coming-soon')
  async getComingSoonMovies(
      @Query() paginationDto: PaginationDto
  ): Promise<Movie[]> {
    return this.moviesService.getComingSoonMovies(paginationDto);
  }

  @Get(':id')
  getDetail(
      @Param('id') id: string,
  ): Promise<Movie> {
    return this.moviesService.getDetail(id);
  }
}

import { Body, Controller, Get, Logger, Param, Post, Query, UseGuards } from '@nestjs/common';
import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';
import { Movie } from './movie.schema';
import { getCoordinates } from '../common/utils';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { PaginationDto } from '../common/pagination.dto';
import { AddMovieDto, GetNowShowingMoviesDto } from './movie.dto';
import { AuthGuard } from '../auth/auth.guard';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { ForAdmin } from '../common/swagger.decorator';
import { range } from "rxjs";
import { concatMap, map, toArray } from "rxjs/operators";

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
  seed(/*@Body() { query, page, year }: { query: string, page: number, year: number }*/) {
    const query = 'Love';

    return range(0, 10)
        .pipe(
            map(i => 2020 - i),
            concatMap(year =>
                range(1, 20).pipe(map(page => ({ page, year })))
            ),
            concatMap(({ year, page }) => this.movieDbService.seed(query, page, year)),
            toArray(),
        );

    // return this.movieDbService.seed(query, page, year);
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
    this.logger.debug(dto);
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

  @Get('most-favorite')
  getMostFavorite(
      @Query() paginationDto: PaginationDto,
  ): Promise<Movie[]> {
    return this.moviesService.getMostFavorite(paginationDto);
  }

  @Get('most-rate')
  getMostRate(
      @Query() paginationDto: PaginationDto,
  ): Promise<Movie[]> {
    return this.moviesService.getMostRate(paginationDto);
  }

  @Get(':id')
  getDetail(
      @Param('id') id: string,
  ): Promise<Movie> {
    return this.moviesService.getDetail(id);
  }
}

@UseGuards(AuthGuard, RolesGuard)
@ApiTags('admin_movies')
@Controller('admin_movies')
export class AdminMoviesController {
  constructor(
      private readonly moviesService: MoviesService,
      private readonly movieDbService: MovieDbService,
  ) {}

  @ForAdmin()
  @Roles('ADMIN')
  @Get()
  getAllMovies(
      @Query() dto: PaginationDto,
  ): Promise<Movie[]> {
    return this.moviesService.getAll(dto);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Post()
  addMovie(
      @Body() dto: AddMovieDto,
  ): Promise<Movie> {
    return this.moviesService.addMovie(dto);
  }

  @ForAdmin()
  @Roles('ADMIN', 'STAFF')
  @Get('search')
  searchByTitle(
      @Query('title') title: string,
  ): Promise<Movie[]> {
    return this.moviesService.searchByTitle(title);
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  removeAdultMovies() {
    return this.movieDbService.removeAdultMovies();
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed2')
  seed() {
    return this.movieDbService.removeMovies();
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed3')
  seed3() {
    return this.movieDbService.removeDup();
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed4')
  seed4() {
    return this.movieDbService.removeShort();
  }
}
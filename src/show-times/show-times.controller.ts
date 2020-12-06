import { Body, Controller, Get, Logger, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ShowTimesService } from './show-times.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { getCoordinates } from '../common/utils';
import { AddShowTimeDto, MovieAndShowTime, TheatreAndShowTime } from './show-time.dto';
import { AuthGuard } from '../auth/auth.guard';
import { LocationDto } from '../common/location.dto';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { ForAdmin } from '../common/swagger.decorator';
import { PaginationDto } from "../common/pagination.dto";
import { ShowTime } from "./show-time.schema";

@ApiTags('show-times')
@UseGuards(AuthGuard)
@Controller('show-times')
export class ShowTimesController {
  private readonly logger = new Logger('ShowTimesController');

  constructor(
      private readonly showTimesService: ShowTimesService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed() {
    return this.showTimesService.seed();
  }

  @Get('movies/:movie_id')
  async getShowTimesByMovieId(
      @Param('movie_id') movieId: string,
      @Query() locationDto: LocationDto,
  ): Promise<TheatreAndShowTime[]> {
    this.logger.debug(`getShowTimesByMovieId ${movieId} ${locationDto.lat}, ${locationDto.lng}`);

    const movieShowTimes = await this.showTimesService.getShowTimesByMovieId(
        movieId,
        getCoordinates(locationDto)
    );

    return movieShowTimes.map(doc => new TheatreAndShowTime(doc));
  }

  @Get('theatres/:theatre_id')
  async getShowTimesByTheatreId(
      @Param('theatre_id') theatreId: string,
  ): Promise<MovieAndShowTime[]> {
    const result = await this.showTimesService.getShowTimesByTheatreId(theatreId);
    return result.map(doc => new MovieAndShowTime(doc));
  }
}

@ApiTags('admin-show-times')
@UseGuards(AuthGuard, RolesGuard)
@Controller('admin-show-times')
export class AdminShowTimesController {
  constructor(
      private readonly showTimesService: ShowTimesService,
  ) {}

  @ForAdmin()
  @Roles('ADMIN')
  @Post()
  addShowTime(
      @Body() dto: AddShowTimeDto,
  ) {
    return this.showTimesService.addShowTime(dto);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Get('theatres/:theatre_id')
  getShowTimesByTheatreId(
      @Param('theatre_id') theatreId: string,
      @Query() dto: PaginationDto,
  ): Promise<ShowTime[]> {
    return this.showTimesService.getShowTimesByTheatreIdAdmin(theatreId, dto);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Get('available-periods')
  getAvailablePeriods(
    @Query('theatre_id') theatreId: string,
    @Query('day') day: string,
  ) {
    return this.showTimesService.getAvailablePeriods(theatreId, day);
  }
}
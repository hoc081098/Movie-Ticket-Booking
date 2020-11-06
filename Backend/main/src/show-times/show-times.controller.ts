import { Controller, Get, Logger, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ShowTimesService } from './show-times.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { getCoordinates } from '../common/utils';
import { MovieAndShowTime, TheatreAndShowTime } from './show-time.dto';
import { AuthGuard } from '../auth/auth.guard';
import { LocationDto } from '../common/location.dto';

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

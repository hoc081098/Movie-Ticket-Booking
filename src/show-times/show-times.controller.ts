import { Controller, Get, Logger, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ShowTimesService } from './show-times.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { getCoordinates } from '../utils';
import { MovieAndTheatre } from './show-time.dto';
import { AuthGuard } from '../auth/auth.guard';

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
      @Query('lat') lat?: string,
      @Query('lng') lng?: string,
  ): Promise<MovieAndTheatre[]> {
    this.logger.debug(`getShowTimesByMovieId ${movieId} ${lat}, ${lng}`);

    const movieShowTimes = await this.showTimesService.getShowTimesByMovieId(
        movieId,
        getCoordinates({ lat, lng })
    );

    return movieShowTimes.map(doc => new MovieAndTheatre(doc));
  }
}

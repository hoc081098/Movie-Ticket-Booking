import { Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { TheatresService } from './theatres.service';
import { AuthGuard } from '../auth/auth.guard';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { LocationDto } from "../common/location.dto";
import { Theatre } from "./theatre.schema";

@ApiTags('theatres')
@UseGuards(AuthGuard)
@Controller('theatres')
export class TheatresController {
  constructor(
      private readonly theatresService: TheatresService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed() {
    return this.theatresService.seed();
  }

  @Get('nearby')
  getNearbyTheatres(
      @Query() dto?: LocationDto,
  ): Promise<Theatre[]> {
    return this.theatresService.getNearbyTheatres(dto);
  }
}

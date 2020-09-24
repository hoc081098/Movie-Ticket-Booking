import { Controller, Post, UseGuards } from '@nestjs/common';
import { TheatresService } from './theatres.service';
import { AuthGuard } from '../auth/auth.guard';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

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
}

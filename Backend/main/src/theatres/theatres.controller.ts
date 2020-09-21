import { Controller, Post } from '@nestjs/common';
import { TheatresService } from './theatres.service';

@Controller('theatres')
export class TheatresController {
  constructor(
      private readonly theatresService: TheatresService,
  ) {}

  @Post('seed')
  seed() {
    return this.theatresService.seed();
  }
}

import { Controller, Post } from '@nestjs/common';
import { ShowTimesService } from './show-times.service';

@Controller('show-times')
export class ShowTimesController {
  constructor(
      private readonly showTimesService: ShowTimesService,
  ) {}

  @Post('seed')
  seed() {
    return this.showTimesService.seed();
  }
}

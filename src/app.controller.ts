import { Controller, Post } from '@nestjs/common';
import { AppService } from './app.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('/')
@Controller()
export class AppController {
  constructor(
      private readonly appService: AppService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('token')
  token() {
    return this.appService.generateToken();
  }
}

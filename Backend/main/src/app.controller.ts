import { Controller, Get, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { ConfigKey, ConfigService } from './config/config.service';
import { AuthGuard } from './auth/auth.guard';

@Controller()
export class AppController {
  constructor(
      private readonly appService: AppService,
      private readonly configService: ConfigService
  ) {
    console.log('>>>', configService.get(ConfigKey.MONGODB_URL));
  }

  @UseGuards(AuthGuard)
  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @UseGuards(AuthGuard)
  @Get('world')
  world(): string {
    return this.appService.getHello();
  }
}

import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from './auth/auth.guard';
import { Roles, RolesGuard } from './auth/roles.guard';

@ApiTags('/')
@Controller()
export class AppController {
  constructor(
      private readonly appService: AppService,
  ) {}

  // @ApiOperation({ summary: 'PRIVATE' })
  // @Post('token')
  // token() {
  //   return this.appService.generateToken();
  // }

  // @UseGuards(AuthGuard, RolesGuard)
  // @Get('/normal')
  // get() {
  //   return 'nice';
  // }

  // @UseGuards(AuthGuard, RolesGuard)
  // @Roles('ADMIN')
  // @Get('/admin')
  // getAdmin() {
  //   return 'nice';
  // }
}

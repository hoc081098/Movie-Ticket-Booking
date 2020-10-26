import {
  Body,
  Controller,
  Delete,
  Get,
  Logger,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
  UseGuards
} from '@nestjs/common';
import { AuthGuard } from '../auth/auth.guard';
import { UsersService } from './users.service';
import { GetFcmToken, GetUser, UserPayload } from '../auth/get-user.decorator';
import { User } from './user.schema';
import { UpdateUserDto } from './update-user.dto';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { PaginationDto } from '../common/pagination.dto';
import { ForAdmin } from '../common/swagger.decorator';

@ApiTags('users')
@Controller('users')
export class UsersController {
  private readonly logger = new Logger('UsersController');

  constructor(
      private readonly usersService: UsersService,
  ) {}

  @Get('me')
  @UseGuards(AuthGuard)
  async me(
      @GetUser('uid') uid: string,
      @GetFcmToken() fcmToken: string,
  ): Promise<User> {
    this.logger.debug(`Get my profile: ${uid} ${fcmToken}`);

    let user = await this.usersService.findByUid(uid);
    if (!user) {
      throw new NotFoundException(`User with uid: ${uid} not found`);
    }
    if (fcmToken) {
      user = await this.usersService.updateFcmToken(user, fcmToken);
    }
    return user;
  }

  @Get(':uid')
  async findById(@Param('uid') uid: string): Promise<User> {
    const user = await this.usersService.findByUid(uid);
    if (!user) {
      throw new NotFoundException(`User with uid: ${uid} not found`);
    }
    return user;
  }

  @Put('me')
  @UseGuards(AuthGuard)
  update(
      @GetUser() user: UserPayload,
      @Body() updateUserDto: UpdateUserDto
  ): Promise<User> {
    this.logger.debug(`Update my profile: ${JSON.stringify(user)}, ${JSON.stringify(updateUserDto)}`);

    return this.usersService.update(user, updateUserDto);
  }


  @ApiOperation({ summary: 'PRIVATE' })
  @UseGuards(AuthGuard, RolesGuard)
  @Post('seed')
  seedUsers() {
    return this.usersService.seedUsers();
  }
}

@ApiTags('admin_users')
@Controller('admin_users')
export class AdminUsersController {
  private readonly logger = new Logger('AdminUsersController');

  constructor(
      private readonly usersService: UsersService,
  ) {}


  @ForAdmin()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Delete(':uid')
  delete(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.delete(uid);
  }

  @ForAdmin()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Get()
  getAllUsers(
      @Query() dto: PaginationDto,
  ): Promise<User[]> {
    return this.usersService.getAllUsers(dto);
  }


  @ForAdmin()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Put(':uid')
  blockUser(
      @Param('uid') uid: string,
      @Body() body: any,
  ): Promise<User> {
    try {
      this.logger.debug(`Block ${uid} ${body}`);
      return this.usersService.blockUser(uid);
    } catch (e) {
      this.logger.debug(`Error: ${e}`);
    }
  }

  @ForAdmin()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Put('unblock/:uid')
  unblockUser(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.unblockUser(uid);
  }

  @ForAdmin()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Put('to_user_role/:uid')
  toUserRole(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.toUserRole(uid);
  }

  @ForAdmin()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Put('to_staff_role/:uid')
  toStaffRole(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.toStaffRole(uid);
  }
}
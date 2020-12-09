import {
  BadRequestException,
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
    this.logger.debug(user, 'user');
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
}

@UseGuards(AuthGuard, RolesGuard)
@ApiTags('admin_users')
@Controller('admin_users')
export class AdminUsersController {
  constructor(
      private readonly usersService: UsersService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Roles('ADMIN')
  @Post('seed')
  seedUsers() {
    return this.usersService.seedUsers();
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Delete(':uid')
  delete(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.delete(uid);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Get()
  getAllUsers(
      @Query() dto: PaginationDto,
  ): Promise<User[]> {
    return this.usersService.getAllUsers(dto);
  }


  @ForAdmin()
  @Roles('ADMIN')
  @Put('block/:uid')
  blockUser(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.blockUser(uid);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Put('unblock/:uid')
  unblockUser(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.unblockUser(uid);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Put('to_user_role/:uid')
  toUserRole(
      @Param('uid') uid: string,
  ): Promise<User> {
    return this.usersService.toUserRole(uid);
  }

  @ForAdmin()
  @Roles('ADMIN')
  @Put('to_staff_role/:uid')
  toStaffRole(
      @Param('uid') uid: string,
      @Body('theatre_id') theatre_id: string,
  ): Promise<User> {
    if (!theatre_id) {
      throw new BadRequestException(`Require theatre_id`);
    }
    return this.usersService.toStaffRole(uid, theatre_id);
  }
}
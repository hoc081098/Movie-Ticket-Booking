import { Body, Controller, Delete, Get, Logger, NotFoundException, Param, Put, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../auth/auth.guard';
import { UsersService } from './users.service';
import { GetUser, UserPayload } from '../auth/get-user.decorator';
import { User } from './user.schema';
import { UpdateUserDto } from './update-user.dto';
import { ApiTags } from '@nestjs/swagger';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { PaginationDto } from '../common/pagination.dto';

@ApiTags('users')
@Controller('users')
export class UsersController {
  private readonly logger = new Logger('UsersController');

  constructor(
      private readonly usersService: UsersService,
  ) {}

  @Get('me')
  @UseGuards(AuthGuard)
  async me(@GetUser('uid') uid: string): Promise<User> {
    this.logger.debug(`Get my profile: ${uid}`);

    const user = await this.usersService.findByUid(uid);
    if (!user) {
      throw new NotFoundException(`User with uid: ${uid} not found`);
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

  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Delete(':uid')
  delete(
      @Param('uid') uid: string,
  ) {
    return this.usersService.delete(uid);
  }

  @UseGuards(AuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Get()
  getAllUsers(
      @Query() dto: PaginationDto,
  ): Promise<User[]> {
    return this.usersService.getAllUsers(dto);
  }
}

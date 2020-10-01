import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../../auth/auth.guard';
import { GetUser, UserPayload } from '../../auth/get-user.decorator';
import { Card } from '../card.dto';
import { ApiTags } from '@nestjs/swagger';
import { UsersService } from '../users.service';

@ApiTags('cards')
@UseGuards(AuthGuard)
@Controller('cards')
export class CardsController {
  constructor(
      private readonly usersService: UsersService,
  ) {}

  @Get()
  getCards(
      @GetUser() user: UserPayload,
  ): Promise<Card[]> {
    return this.usersService.getCards(user);
  }
}

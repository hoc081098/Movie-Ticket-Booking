import { Body, Controller, Delete, Get, Param, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../../auth/auth.guard';
import { GetUser, UserPayload } from '../../auth/get-user.decorator';
import { AddCardDto, Card } from './card.dto';
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

  @Post()
  addCard(
      @GetUser() userPayload: UserPayload,
      @Body() cardDto: AddCardDto
  ) {
    return this.usersService.addCard(userPayload, cardDto);
  }

  @Delete(':id')
  removeCard(
      @GetUser() userPayload: UserPayload,
      @Param('id') cardId: string
  ): Promise<'SUCCESS'> {
    return this.usersService.removeCard(
        userPayload,
        cardId
    );
  }
}

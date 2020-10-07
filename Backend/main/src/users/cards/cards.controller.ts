import { BadRequestException, Body, Controller, Delete, Get, Param, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../../auth/auth.guard';
import { GetUser, UserPayload } from '../../auth/get-user.decorator';
import { AddCardDto, Card } from './card.dto';
import { ApiTags } from '@nestjs/swagger';
import { UsersService } from '../users.service';
import dayjs = require('dayjs');

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
    const current = dayjs();
    const currentYear = current.year() % 100;

    if (cardDto.exp_year < currentYear) {
      throw new BadRequestException('Invalid exp_year. exp_year must be equal to or greater than current year.');
    }

    const currentMonth = current.month() + 1;
    if (cardDto.exp_year === currentYear && cardDto.exp_month < currentMonth) {
      throw new BadRequestException('Invalid exp_month. exp_month must be equal to or greater than current month.');
    }

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

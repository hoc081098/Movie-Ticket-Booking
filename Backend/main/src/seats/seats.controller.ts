import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { SeatsService } from './seats.service';
import { Seat } from './seat.schema';
import { Ticket } from './ticket.schema';

@ApiTags('seats')
@UseGuards(AuthGuard)
@Controller('seats')
export class SeatsController {
  constructor(
      private readonly seatsService: SeatsService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed(@Body() { id }: { id: string }): Promise<Seat[]> {
    return this.seatsService.seed(id);
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed-tickets')
  seedTickets() {
    return this.seatsService.seedTickets();
  }

  @ApiOperation({
    description: 'Populated seat'
  })
  @Get('tickets/show-times/:show_time_id')
  getTicketsByShowTimeId(
      @Param('show_time_id') showTimeId: string,
  ): Promise<Ticket[]> {
    return this.seatsService.getTicketsByShowTimeId(showTimeId);
  }
}

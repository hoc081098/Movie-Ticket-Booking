import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { SeatsService } from './seats.service';
import { Seat } from './seat.schema';
import { Ticket } from './ticket.schema';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { checkStaffPermission } from "../common/utils";
import { GetUser, UserPayload } from "../auth/get-user.decorator";

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
      @GetUser() userPayload: UserPayload,
  ): Promise<Ticket[]> {
    return this.seatsService.getTicketsByShowTimeId(showTimeId, userPayload);
  }
}

@ApiTags('admin-seats')
@UseGuards(AuthGuard, RolesGuard)
@Controller('admin-seats')
export class AdminSeatsController {
  constructor(
      private readonly seatsService: SeatsService,
  ) {}

  @ApiOperation({
    description: 'Populated seat'
  })
  @Roles('ADMIN', 'STAFF')
  @Get('tickets/show-times/:show_time_id')
  getTicketsByShowTimeId(
      @Param('show_time_id') showTimeId: string,
      @GetUser() userPayload: UserPayload,
  ): Promise<Ticket[]> {
    return this.seatsService.getTicketsByShowTimeId(showTimeId, userPayload);
  }

  @Roles('ADMIN', 'STAFF')
  @Get('seats/theatres/:theatre_id')
  getSeatsByTheatreId(
      @Param('theatre_id') theatre_id: string,
      @GetUser() userPayload: UserPayload,
  ) {
    checkStaffPermission(userPayload, theatre_id);
    return this.seatsService.getSeatsByTheatreId(theatre_id);
  }
}
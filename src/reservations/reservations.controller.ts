import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { GetUser, UserPayload } from '../auth/get-user.decorator';
import { CreateReservationDto } from './reservation.dto';
import { ReservationsService } from './reservations.service';
import { Reservation } from './reservation.schema';

@ApiTags('reservations')
@UseGuards(AuthGuard)
@Controller('reservations')
export class ReservationsController {
  constructor(
      private readonly reservationsService: ReservationsService,
  ) {}

  @Post()
  createReservation(
      @GetUser() userPayload: UserPayload,
      @Body() dto: CreateReservationDto,
  ): Promise<Reservation> {
    return this.reservationsService.createReservation(
        userPayload,
        dto,
    );
  }
}

import { Body, Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { GetUser, UserPayload } from '../auth/get-user.decorator';
import { CreateReservationDto } from './reservation.dto';
import { ReservationsService } from './reservations.service';
import { Reservation } from './reservation.schema';
import { PaginationDto } from '../common/pagination.dto';
import { RolesGuard, Roles } from 'src/auth/roles.guard';
import { ForAdmin } from 'src/common/swagger.decorator';

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

  @Get()
  getReservations(
      @GetUser() userPayload: UserPayload,
      @Query() dto: PaginationDto,
  ) {
    return this.reservationsService.getReservations(
        userPayload,
        dto,
    );
  }

  @Get(':id')
  getReservationById(
      @GetUser() userPayload: UserPayload,
      @Param('id') id: string,
  ) {
    return this.reservationsService.getReservationById(
        userPayload,
        id,
    );
  }

  @Get('qrcode/:id')
  getQrCode(
      @Param('id')  id: string,
      @GetUser() userPayload: UserPayload,
  ): Promise<string> {
    return this.reservationsService.getQrCode(
        id,
        userPayload,
    )
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Get('seed')
  seed() {
    return this.reservationsService.seed();
  }
}


@ApiTags('admin-reservations')
@UseGuards(AuthGuard, RolesGuard)
@Controller('admin-reservations')
export class AdminReservationsController {
  constructor(
      private readonly reservationsService: ReservationsService,
  ) {}

  @ForAdmin()
  @Roles('ADMIN', 'STAFF')
  @Get('show-times/:show_time_id')
  getReservationsByShowTimeId(
      @Param('show_time_id') show_time_id: string,
      @GetUser() userPayload: UserPayload,
  ) {
    return this.reservationsService.getReservationsByShowTimeId(
        show_time_id,
        userPayload
    );
  }

  @ForAdmin()
  @Roles('ADMIN', 'STAFF')
  @Get(':id')
  getReservationById(
      @Param('id') id: string,
      @GetUser() userPayload: UserPayload,
  ) {
    return this.reservationsService.getReservationById(userPayload, id);
  }
}
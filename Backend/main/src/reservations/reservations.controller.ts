import { Controller, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';

@ApiTags('reservations')
@UseGuards(AuthGuard)
@Controller('reservations')
export class ReservationsController {}

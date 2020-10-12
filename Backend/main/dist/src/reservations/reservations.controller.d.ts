import { UserPayload } from '../auth/get-user.decorator';
import { CreateReservationDto } from './reservation.dto';
import { ReservationsService } from './reservations.service';
import { Reservation } from './reservation.schema';
export declare class ReservationsController {
    private readonly reservationsService;
    constructor(reservationsService: ReservationsService);
    createReservation(userPayload: UserPayload, dto: CreateReservationDto): Promise<Reservation>;
}

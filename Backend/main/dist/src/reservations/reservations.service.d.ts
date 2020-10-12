import { UserPayload } from '../auth/get-user.decorator';
import { CreateReservationDto } from './reservation.dto';
import { Model } from 'mongoose';
import { Reservation } from './reservation.schema';
import { UsersService } from '../users/users.service';
import { Product } from '../products/product.schema';
import { Ticket } from '../seats/ticket.schema';
import { AppGateway } from '../socket/app.gateway';
export declare class ReservationsService {
    private readonly reservationModel;
    private readonly productModel;
    private readonly ticketModel;
    private readonly usersService;
    private readonly appGateway;
    private readonly logger;
    constructor(reservationModel: Model<Reservation>, productModel: Model<Product>, ticketModel: Model<Ticket>, usersService: UsersService, appGateway: AppGateway);
    createReservation(userPayload: UserPayload, dto: CreateReservationDto): Promise<Reservation>;
    private saveAndUpdate;
    private checkProduct;
    private checkSeats;
}

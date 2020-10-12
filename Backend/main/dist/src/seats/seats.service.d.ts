import { Model } from 'mongoose';
import { Seat } from './seat.schema';
import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from '../show-times/show-time.schema';
import { Ticket } from './ticket.schema';
export declare class SeatsService {
    private readonly seatModel;
    private readonly theatreModel;
    private readonly showTimeModel;
    private readonly ticketModel;
    private readonly logger;
    private seedChange;
    constructor(seatModel: Model<Seat>, theatreModel: Model<Theatre>, showTimeModel: Model<ShowTime>, ticketModel: Model<Ticket>);
    private findShowTimeById;
    private getSeatsByShowTimeId;
    private seedTicketsForSingleShowTime;
    seed(theatreId: string): Promise<Seat[]>;
    seedTickets(): Promise<Ticket[]>;
    getTicketsByShowTimeId(id: string): Promise<Ticket[]>;
}
declare global {
    interface Array<T> {
        random(): T | undefined;
    }
}

import { SeatsService } from './seats.service';
import { Seat } from './seat.schema';
import { Ticket } from './ticket.schema';
export declare class SeatsController {
    private readonly seatsService;
    constructor(seatsService: SeatsService);
    seed({ id }: {
        id: string;
    }): Promise<Seat[]>;
    seedTickets(): Promise<Ticket[]>;
    getTicketsByShowTimeId(showTimeId: string): Promise<Ticket[]>;
}

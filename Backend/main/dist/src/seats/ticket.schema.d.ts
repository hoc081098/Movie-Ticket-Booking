import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class Ticket extends Document {
    seat: any;
    show_time: any;
    reservation?: any | null;
    price: number;
    is_active: boolean;
}
export declare const TicketSchema: MongooseSchema<any>;

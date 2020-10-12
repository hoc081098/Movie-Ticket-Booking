import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class Seat extends Document {
    row: string;
    column: number;
    count: number;
    coordinates: [number, number];
    theatre: any;
    room: string;
    is_active: boolean;
}
export declare const SeatSchema: MongooseSchema<any>;

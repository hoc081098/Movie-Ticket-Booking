import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class ShowTime extends Document {
    movie: any;
    theatre: any;
    room: string;
    start_time: Date;
    end_time: Date;
    is_active: boolean;
}
export declare const ShowTimeSchema: MongooseSchema<any>;

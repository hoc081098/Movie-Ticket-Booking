import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class Reservation extends Document {
    user: any;
    show_time: any;
    phone_number: string;
    email: string;
    products: any[];
    original_price: number;
    total_price: number;
    promotion_id?: any;
    payment_intent_id: string;
    is_active: boolean;
}
export declare const ReservationSchema: MongooseSchema<any>;

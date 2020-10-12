import { Document } from 'mongoose';
export declare class Promotion extends Document {
    name: string;
    start_time: string;
    end_time: string;
    discount: number;
    is_active: boolean;
}
export declare const PromotionSchema: import("mongoose").Schema<any>;

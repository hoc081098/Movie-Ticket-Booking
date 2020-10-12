import { Document } from 'mongoose';
export declare class Product extends Document {
    name: string;
    price: number;
    description: string;
    image?: string;
    is_active: boolean;
}
export declare const ProductSchema: import("mongoose").Schema<any>;

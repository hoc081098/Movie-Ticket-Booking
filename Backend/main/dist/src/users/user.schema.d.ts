import { Document, Schema as MongooseSchema } from 'mongoose';
import { Location } from '../common/location.inteface';
export declare class User extends Document {
    uid: string;
    email: string;
    phone_number?: string;
    full_name: string;
    gender: 'MALE' | 'FEMALE';
    avatar?: string;
    address?: string;
    birthday?: Date;
    location?: Location;
    role: 'ADMIN' | 'USER' | 'STAFF';
    is_completed: boolean;
    is_active: boolean;
    stripe_customer_id?: string;
    favorite_movie_ids?: Record<string, Date> | null;
}
export declare const UserSchema: MongooseSchema<any>;

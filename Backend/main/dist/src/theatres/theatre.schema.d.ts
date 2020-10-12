import { Document } from 'mongoose';
import { Location } from '../common/location.inteface';
export declare class Theatre extends Document {
    name: string;
    address: string;
    location: Location;
    phone_number: string;
    email?: string;
    description: string;
    room_summary: string;
    opening_hours: string;
    rooms: string[];
    is_active: boolean;
}
export declare const TheatreSchema: import("mongoose").Schema<any>;

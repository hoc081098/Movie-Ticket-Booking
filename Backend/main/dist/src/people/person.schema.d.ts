import { Document } from 'mongoose';
export declare class Person extends Document {
    avatar?: string;
    full_name: string;
    is_active: boolean;
}
export declare const PersonSchema: import("mongoose").Schema<any>;

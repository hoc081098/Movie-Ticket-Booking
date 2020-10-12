import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class Movie extends Document {
    title: string;
    trailer_video_url?: string;
    poster_url?: string;
    overview?: string;
    released_date: Date;
    duration: number;
    directors: any[];
    actors: any[];
    original_language: string;
    age_type: 'P' | 'C13' | 'C16' | 'C18';
    total_rate: number;
    rate_star: number;
    total_favorite: number;
    is_active: boolean;
}
export declare const MovieSchema: MongooseSchema<any>;

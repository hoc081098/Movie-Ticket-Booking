import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class Comment extends Document {
    content: string;
    rate_star: number;
    user: any;
    movie: any;
    is_active: boolean;
}
export declare const CommentSchema: MongooseSchema<any>;

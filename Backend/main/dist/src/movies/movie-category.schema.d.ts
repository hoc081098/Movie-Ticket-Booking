import { Document, Schema as MongooseSchema } from 'mongoose';
export declare class MovieCategory extends Document {
    movie_id: MongooseSchema.Types.ObjectId;
    category_id: MongooseSchema.Types.ObjectId;
}
export declare const MovieCategorySchema: MongooseSchema<any>;

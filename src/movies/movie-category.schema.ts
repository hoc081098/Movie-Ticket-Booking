import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'movie_category',
})
export class MovieCategory extends Document {
  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'movies',
    required: true,
  })
  movie_id: MongooseSchema.Types.ObjectId;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'categories',
    required: true,
  })
  category_id: MongooseSchema.Types.ObjectId;
}

export const MovieCategorySchema = SchemaFactory.createForClass(MovieCategory);
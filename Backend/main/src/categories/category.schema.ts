import { Document } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  toJSON: {
    virtuals: true,
  },
  collection: 'categories'
})
export class Category extends Document {
  @Prop({ required: true })
  name: string;
}

export const CategorySchema = SchemaFactory.createForClass(Category);

CategorySchema.virtual('movies', {
  ref: 'movie_category',
  localField: '_id',
  foreignField: 'category_id',
});
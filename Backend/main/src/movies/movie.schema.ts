import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  toJSON: {
    virtuals: true
  }
})
export class Movie extends Document {
  @Prop({ required: true })
  title: string;

  @Prop()
  trailer_video_url?: string;

  @Prop({ required: true })
  poster_url: string;

  @Prop({ required: true })
  overview: string;

  @Prop({ required: true })
  released_date: Date;

  @Prop({ required: true })
  duration: number;

  @Prop({
    type: [
      {
        type: MongooseSchema.Types.ObjectId,
        ref: 'people',
        required: true,
      }
    ],
    required: true,
  })
  directors: MongooseSchema.Types.ObjectId[];

  @Prop({
    type: [
      {
        type: MongooseSchema.Types.ObjectId,
        ref: 'people',
        required: true,
      }
    ],
    required: true,
  })
  actors: MongooseSchema.Types.ObjectId[];

  @Prop({ required: true })
  nation: string;

  @Prop({ default: true })
  is_active: boolean;
}

export const MovieSchema = SchemaFactory.createForClass(Movie);

MovieSchema.virtual('categories', {
  ref: 'movie_category',
  localField: '_id',
  foreignField: 'movie_id',
});
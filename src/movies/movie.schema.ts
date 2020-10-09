import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  toJSON: {
    virtuals: true
  },
  timestamps: true,
})
export class Movie extends Document {
  @Prop({ required: true })
  title: string;

  @Prop()
  trailer_video_url?: string;

  @Prop()
  poster_url?: string;

  @Prop()
  overview?: string;

  @Prop({ required: true })
  released_date: Date;

  @Prop({ required: true })
  duration: number;

  @Prop({
    type: [
      {
        type: [MongooseSchema.Types.ObjectId],
        ref: 'Person',
        required: true,
      }
    ],
    required: true,
  })
  directors: any[];

  @Prop({
    type: [
      {
        type: [MongooseSchema.Types.ObjectId],
        ref: 'Person',
        required: true,
      }
    ],
    required: true,
  })
  actors: any[];

  @Prop({ required: true })
  original_language: string;

  @Prop({
    type: String,
    enum: ['P', 'C13', 'C16', 'C18'],
    default: 'P',
    required: true,
  })
  age_type: 'P' | 'C13' | 'C16' | 'C18';

  @Prop()
  total_rate: number;

  @Prop()
  rate_star: number;

  @Prop()
  total_favorite: number;

  @Prop({ default: true })
  is_active: boolean;
}

export const MovieSchema = SchemaFactory.createForClass(Movie);

MovieSchema.virtual('categories', {
  ref: 'MovieCategory',
  localField: '_id',
  foreignField: 'movie_id',
});
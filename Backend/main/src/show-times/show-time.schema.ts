import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'show_times',
  timestamps: true,
})
export class ShowTime extends Document {
  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Movie',
    required: true,
  })
  movie: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Theatre',
    required: true,
  })
  theatre: any;

  @Prop({ required: true })
  room: string;

  @Prop({ required: true })
  start_time: Date;

  @Prop({ required: true })
  end_time: Date;

  @Prop({ default: true })
  is_active: boolean;
}

export const ShowTimeSchema = SchemaFactory.createForClass(ShowTime);
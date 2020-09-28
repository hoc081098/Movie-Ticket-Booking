import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'seats',
  timestamps: true,
})
export class Seat extends Document {
  @Prop({ required: true })
  row: string;

  @Prop({ required: true })
  column: number;

  @Prop({ required: true })
  count: number;

  @Prop({
    type: [Number],
    required: true,
  })
  coordinates: [number, number];

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Theatre',
    required: true,
  })
  theatre: any;

  @Prop({ required: true })
  room: string;

  @Prop({ default: true })
  is_active: boolean;
}

export const SeatSchema = SchemaFactory.createForClass(Seat);
import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'tickets',
  timestamps: true,
})
export class Ticket extends Document {
  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Seat',
    required: true,
  })
  seat: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'ShowTime',
    required: true,
  })
  show_time: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Reservation',
    default: null,
  })
  reservation?: any | null;

  @Prop({ required: true })
  price: number;

  @Prop()
  is_active: boolean;
}

export const TicketSchema = SchemaFactory.createForClass(Ticket);
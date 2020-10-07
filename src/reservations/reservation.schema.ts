import { Prop, Schema, SchemaFactory, } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';

@Schema({
  collection: 'reservations',
  timestamps: true,
})
export class Reservation extends Document {
  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'User',
    required: true,
  })
  user: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'ShowTime',
    required: true,
  })
  show_time: any;

  @Prop({ required: true })
  phone_number: string;

  @Prop({ required: true })
  email: string;

  @Prop({
    type: [
      {
        id: {
          type: MongooseSchema.Types.ObjectId,
          ref: 'Product',
          required: true,
        },
        quantity: {
          type: Number,
          required: true,
        },
      },
    ],
    required: true,
  })
  products: any[];

  @Prop({ required: true })
  original_price: number;

  @Prop({ required: true })
  total_price: number;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Promotion',
  })
  promotion_id?: any;

  @Prop({ required: true })
  payment_intent_id: string;

  @Prop()
  is_active: boolean;
}

export const ReservationSchema = SchemaFactory.createForClass(Reservation);
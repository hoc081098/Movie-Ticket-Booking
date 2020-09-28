import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({
  collection: 'promotions',
  timestamps: true
})
export class Promotion extends Document {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  start_time: string;

  @Prop({ required: true })
  end_time: string;

  @Prop({ required: true })
  discount: number;

  @Prop()
  is_active: boolean;
}

export const PromotionSchema = SchemaFactory.createForClass(Promotion);
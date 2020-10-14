import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';

@Schema({
  collection: 'promotions',
  timestamps: true
})
export class Promotion extends Document {
  @Prop({ required: true })
  code: string;

  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  start_time: Date;

  @Prop({ required: true })
  end_time: Date;

  @Prop({ required: true })
  discount: number;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'ShowTime',
    required: true,
  })
  show_time: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'User',
    required: true,
  })
  creator: any;

  @Prop({
    type: MongooseSchema.Types.Mixed,
    default: {},
  })
  user_ids_used?: Record<string, any> | null;

  @Prop()
  is_active: boolean;
}

export const PromotionSchema = SchemaFactory.createForClass(Promotion);
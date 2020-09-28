import { Document } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'products',
  timestamps: true,
})
export class Product extends Document {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  price: number;

  @Prop({ required: true })
  description: string;

  @Prop()
  image?: string;

  @Prop()
  is_active: boolean;
}

export const ProductSchema = SchemaFactory.createForClass(Product);
import { Document } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'people',
  timestamps: true,
})
export class Person extends Document {
  @Prop()
  avatar?: string;

  @Prop({ required: true })
  full_name: string;

  @Prop({ default: true })
  is_active: boolean;
}

export const PersonSchema = SchemaFactory.createForClass(Person);
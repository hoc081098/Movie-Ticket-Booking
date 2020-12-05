import { Document } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Location } from '../common/location.inteface';

@Schema({
  collection: 'theatres',
  timestamps: true,
})
export class Theatre extends Document {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  address: string;

  @Prop(
      {
        type: {
          type: String,
          enum: ['Point'],
          required: true,
        },
        coordinates: {
          type: [Number],
          required: true,
        }
      }
  )
  location: Location;

  @Prop({ required: true })
  phone_number: string;

  @Prop()
  email?: string;

  @Prop({ required: true })
  description: string;

  @Prop({ required: true })
  room_summary: string;

  @Prop({ required: true })
  opening_hours: string;

  @Prop({
    type: [String],
    required: true,
  })
  rooms: string[];

  @Prop({ default: true })
  is_active: boolean;

  @Prop()
  thumbnail?: string | null;

  @Prop()
  cover?: string | null;
}

export const TheatreSchema = SchemaFactory.createForClass(Theatre);
TheatreSchema.index({ location: '2dsphere' });
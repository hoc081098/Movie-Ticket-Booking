import { Document } from 'mongoose';
import { Prop, raw, Schema, SchemaFactory } from '@nestjs/mongoose';

export interface Location {
  type: 'Point',
  coordinates: [number, number];
}

@Schema()
export class User extends Document {
  @Prop({ required: true })
  uid: string;

  @Prop({ required: true })
  email: string;

  @Prop()
  phone_number: string;

  @Prop({ required: true })
  full_name: string;

  @Prop({ required: true })
  gender: 'MALE' | 'FEMALE';

  @Prop()
  avatar: string;

  @Prop()
  address: string;

  @Prop()
  birthday: Date;

  @Prop(
      raw({
        type: {
          type: String,
          enum: ['Point'],
          required: true,
        },
        coordinates: {
          type: [Number],
          required: true,
        }
      })
  )
  location: Location;

  @Prop()
  role: 'ADMIN' | 'USER';

  @Prop({ default: false })
  is_completed: boolean;

  @Prop({ default: false })
  is_active: boolean;
}

export const UserSchema = SchemaFactory.createForClass(User);
import { Document } from 'mongoose';
import { Prop, raw, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Location } from '../location.inteface';

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

  @Prop({
    type: String,
    enum: ['MALE', 'FEMALE'],
    required: true,
    default: 'MALE',
  })
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

  @Prop({
    type: String,
    enum: ['ADMIN', 'ADMIN'],
    required: true,
    default: 'USER',
  })
  role: 'ADMIN' | 'USER';

  @Prop({ default: false })
  is_completed: boolean;

  @Prop({ default: true })
  is_active: boolean;
}

export const UserSchema = SchemaFactory.createForClass(User);
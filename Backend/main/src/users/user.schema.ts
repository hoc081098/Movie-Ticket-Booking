import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Location } from '../common/location.inteface';

@Schema({
  timestamps: true,
})
export class User extends Document {
  @Prop({ required: true })
  uid: string;

  @Prop({ required: true })
  email: string;

  @Prop()
  phone_number?: string;

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
  avatar?: string;

  @Prop()
  address?: string;

  @Prop()
  birthday?: Date;

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
  location?: Location;

  @Prop({
    type: String,
    enum: ['ADMIN', 'USER', 'STAFF'],
    required: true,
    default: 'USER',
  })
  role: 'ADMIN' | 'USER' | 'STAFF';

  @Prop({ default: false })
  is_completed: boolean;

  @Prop({ default: true })
  is_active: boolean;

  @Prop()
  stripe_customer_id?: string;

  @Prop({
    type: MongooseSchema.Types.Mixed,
    default: {},
  })
  favorite_movie_ids?: Record<string, Date> | null;

  @Prop({
    type: [String],
    default: [],
  })
  tokens: string[];

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Theatre',
    default: null,
  })
  theatre?: any | null;
}

export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.index({ uid: 1 });
import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  collection: 'notifications',
  timestamps: true,
})
export class Notification extends Document {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  body: string;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'User',
  })
  to_user: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Reservation',
  })
  reservation: any;
}

export const NotificationSchema = SchemaFactory.createForClass(Notification);
NotificationSchema.index({ to_user: 1 });
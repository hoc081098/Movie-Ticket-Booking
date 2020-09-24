import { Document, Schema as MongooseSchema } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  timestamps: true
})
export class Comment extends Document {
  @Prop({ required: true })
  content: string;

  @Prop({ required: true })
  rate_star: number;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'User',
    required: true,
  })
  user: any;

  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'Movie',
    required: true,
  })
  movie: any;

  @Prop({ default: true })
  is_active: boolean;
}

export const CommentSchema = SchemaFactory.createForClass(Comment);
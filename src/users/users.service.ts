import { Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { User } from './user.schema';
import { InjectModel } from '@nestjs/mongoose';

@Injectable()
export class UsersService {
  constructor(
      @InjectModel(User.name) private readonly userModel: Model<User>,
  ) {}

  findByUid(uid: string): Promise<User | undefined> {
    return this.userModel.findOne({ uid }).exec();
  }
}

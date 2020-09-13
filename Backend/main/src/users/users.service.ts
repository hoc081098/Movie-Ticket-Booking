import { Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { User } from './user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { UpdateUserDto } from './update-user.dto';
import { UserPayload } from '../auth/get-user.decorator';

@Injectable()
export class UsersService {
  constructor(
      @InjectModel(User.name) private readonly userModel: Model<User>,
  ) {}

  findByUid(uid: string): Promise<User | undefined> {
    return this.userModel.findOne({ uid }).exec();
  }

  update(user: UserPayload, updateUserDto: UpdateUserDto): Promise<User> {
    const update: Partial<Pick<User, keyof User>> = {
      ...updateUserDto,
      ...user,
      'is_completed': true,
      'location': updateUserDto.location
          ? {
            type: 'Point',
            coordinates: [
              updateUserDto.location[0],
              updateUserDto.location[1]
            ],
          }
          : undefined,
    };
    return this.userModel
        .findOneAndUpdate(
            { uid: user.uid },
            update,
            { upsert: true, new: true }
        )
        .exec();
  }
}

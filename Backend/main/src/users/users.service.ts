import { Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { User } from './user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { UpdateUserDto } from './update-user.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { Location } from '../common/location.inteface';

@Injectable()
export class UsersService {
  constructor(
      @InjectModel(User.name) private readonly userModel: Model<User>,
  ) {}

  findByUid(uid: string): Promise<User | undefined> {
    return this.userModel.findOne({ uid }).exec();
  }

  update(user: UserPayload, updateUserDto: UpdateUserDto): Promise<User> {
    const update: Omit<UpdateUserDto, 'location'>
        & UserPayload
        & { is_completed: boolean, location?: Location | number[] } = {
      ...updateUserDto,
      ...user,
      'is_completed': true,
    };

    const numbers: number[] = updateUserDto.location;
    if (numbers) {
      update.location = {
        type: 'Point',
        coordinates: [
          numbers[0],
          numbers[1]
        ],
      };
    }

    return this.userModel
        .findOneAndUpdate(
            { uid: user.uid },
            update as Partial<Pick<User, keyof User>>,
            { upsert: true, new: true }
        )
        .exec();
  }
}

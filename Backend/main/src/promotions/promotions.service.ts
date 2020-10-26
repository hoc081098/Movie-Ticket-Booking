import { Injectable, Logger } from '@nestjs/common';
import { UserPayload } from '../auth/get-user.decorator';
import { InjectModel } from '@nestjs/mongoose';
import { CreateDocumentDefinition, Model, Types } from 'mongoose';
import { Promotion } from './promotion.schema';
import { checkCompletedLogin } from '../common/utils';
import { ShowTime } from '../show-times/show-time.schema';
import * as faker from 'faker';
import * as dayjs from 'dayjs';
import slugify from 'slugify';
import { User } from '../users/user.schema';

@Injectable()
export class PromotionsService {
  private readonly logger = new Logger(PromotionsService.name);

  constructor(
      @InjectModel(Promotion.name) private readonly promotionModel: Model<Promotion>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
  ) {}

  async getByShowTimeIdForCurrentUser(userPayload: UserPayload, showTimeId: string): Promise<Promotion[]> {
    const user = checkCompletedLogin(userPayload);
    const now = new Date();

    return await this.promotionModel.find({
      show_time: showTimeId,
      start_time: { $lte: now },
      end_time: { $gte: now },
      [`user_ids_used.${user._id}`]: null,
      is_active: true,
    }).exec();
  }

  async seed(userPayload: UserPayload) {
    const user = checkCompletedLogin(userPayload);

    const now = new Date();
    const end = dayjs().startOf('day').add(7, 'day').toDate();

    const showTimes = await this.showTimeModel.find({ start_time: { $gte: now } });

    let count = 0;
    for (const showTime of showTimes) {
      for (let i = 0; i < 10; i++) {
        const name = faker.lorem.words(5);
        const code = slugify(name, '_');

        const doc: Omit<CreateDocumentDefinition<Promotion>, '_id'> = {
          code,
          discount: Math.random() * 0.5,
          end_time: end,
          is_active: true,
          name,
          start_time: now,
          user_ids_used: null,
          creator: user._id,
          show_time: showTime._id,
        };

        await this.promotionModel.create(doc);
        ++count;

        this.logger.debug(`Done ${count}`);
      }
    }

    return count;
  }

  checkValid(promotion_id: string, user: User): Promise<Promotion | null> {
    const now = new Date();
    return this.promotionModel.findOne({
      _id: promotion_id,
      start_time: { $lte: now },
      end_time: { $gte: now },
      [`user_ids_used.${user._id}`]: null,
      is_active: true,
    }).exec();
  }

  async markUsed(promotion: Promotion, user: User): Promise<void> {
    if (!promotion.user_ids_used) {
      promotion.user_ids_used = {};
    }
    const userId = (user._id as Types.ObjectId).toHexString();
    promotion.user_ids_used[userId] = userId;

    promotion.markModified('user_ids_used');
    await promotion.save();
  }
}

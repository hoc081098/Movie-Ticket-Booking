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
  ) {
  }

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

    const now = dayjs().utcOffset(420, false).startOf('day').subtract(1, 'day');
    const end = now.add(10, 'day').toDate();

    const showTimes = [
      ...(await this.showTimeModel
          .find({ start_time: { $gte: now.toDate() } })
          .sort({ start_time: -1 })
          .limit(400)),
      ...(await this.showTimeModel
          .find({ start_time: { $gte: now.toDate() } })
          .sort({ start_time: 1 })
          .limit(300)),
    ];

    const infos = [
      {
        code: 'christmas_2020',
        name: 'Mừng Giáng sinh giảm 5%',
        discount: 0.05,
      },
      {
        code: 'new_year_2021',
        name: 'Giảm 10% năm mới 2021',
        discount: 0.1,
      },
    ];

    let count = 0;
    for (const showTime of showTimes) {

      for (const info of infos) {
        if (await this.promotionModel.findOne({ code: info.code, name: info.name, show_time: showTime._id })) {
          this.logger.debug(`Dup`);
          continue;
        }

        const doc: Omit<CreateDocumentDefinition<Promotion>, '_id'> = {
          code: info.code,
          discount: info.discount,
          end_time: end,
          is_active: true,
          name: info.name,
          start_time: now.toDate(),
          user_ids_used: null,
          creator: user._id,
          show_time: showTime._id,
        };
        await this.promotionModel.create(doc);
      }

      this.logger.debug(`Done ${count++}`);
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

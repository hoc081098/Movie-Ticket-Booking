import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { User } from '../users/user.schema';
import { Reservation } from '../reservations/reservation.schema';
import { InjectModel } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';
import { CreateDocumentDefinition, Model } from 'mongoose';
import { Notification } from './notification.schema';
import { FirebaseMessagingService } from '@aginix/nestjs-firebase-admin';
import * as admin from 'firebase-admin';
import { CreatedReservation } from '../reservations/reservations.service';
import { PaginationDto } from "../common/pagination.dto";
import { UserPayload } from "../auth/get-user.decorator";
import { checkCompletedLogin, getSkipLimit } from "../common/utils";
import { identity } from 'rxjs';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
      @InjectModel(User.name) private readonly userModel: Model<User>,
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Notification.name) private readonly notificationModel: Model<Notification>,
      private readonly firebaseMessagingService: FirebaseMessagingService,
  ) {
  }

  async pushNotification(user: User, reservation: CreatedReservation): Promise<void> {
    const tokens = user.tokens;
    this.logger.debug(`Tokens: ${tokens.length} ${JSON.stringify(tokens)}`);

    if (!tokens || tokens.length === 0) {
      return;
    }

    const movie = reservation.show_time.movie;

    const notificationDoc: Omit<CreateDocumentDefinition<Notification>, '_id'> = {
      title: `Ticket booking successfully: ${movie.title}`,
      body: `Please check email to get ticket`,
      to_user: user._id,
      reservation: reservation._id,
    };
    const notification = await this.notificationModel.create(notificationDoc);

    const data: Record<string, string> = Object.entries(notification.toJSON()).reduce(
        (acc, e) => {
          const [k, v] = e;
          const newV: string = typeof v === 'string'
              ? v
              : v instanceof mongoose.Types.ObjectId
                  ? (v as mongoose.Types.ObjectId).toHexString()
                  : v?.toString();
          return { ...acc, [k]: newV };
        },
        { image: movie.poster_url ?? '' } as Record<string, string>
    );
    const payload: admin.messaging.MessagingPayload = {
      data,
      notification: {
        title: notificationDoc.title,
        body: notificationDoc.body,
        image: movie.poster_url ?? '',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    const distinctToken = tokens.distinct();
    this.logger.debug(`Distinct token: ${distinctToken.length} ${JSON.stringify(distinctToken)}`);
    const response = await this.firebaseMessagingService.sendToDevice(distinctToken, payload);

    // For each message check if there was an error.
    const tokensToRemove = new Set<string>();
    response.results.forEach((result, index) => {
      const error = result.error;

      if (error) {
        this.logger.error(`Failure sending notification to: ${tokens[index]} ${error}`);
        // Cleanup the tokens who are not registered anymore.
        if (error.code === 'messaging/invalid-registration-token' ||
            error.code === 'messaging/registration-token-not-registered') {
          tokensToRemove.add(tokens[index]);
        }
      }
    });

    if (tokensToRemove.size > 0) {
      await this.userModel.updateOne(
          { uid: user.uid },
          { tokens: distinctToken.filter(t => !tokensToRemove.has(t)) }
      );
    } else {
      await this.userModel.updateOne(
          { uid: user.uid },
          { tokens: distinctToken }
      );
    }

    this.logger.debug(`Pushed payload: ${JSON.stringify(payload)}`);
  }

  async getNotifications(
      userPayload: UserPayload,
      dto: PaginationDto,
  ): Promise<Notification[]> {
    const user = checkCompletedLogin(userPayload);
    const { limit, skip } = getSkipLimit(dto);

    return await this.notificationModel
        .find({ to_user: user._id })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .populate({
          path: 'reservation',
          populate: {
            path: 'show_time',
            populate: [
              { path: 'theatre' },
              { path: 'movie' },
            ]
          }
        })
        .exec();
  }

  async getNotificationById(id: string): Promise<Notification> {
    const notification = await this.notificationModel
        .findById(id)
        .populate({
          path: 'reservation',
          populate: {
            path: 'show_time',
            populate: [
              { path: 'theatre' },
              { path: 'movie' },
            ]
          }
        })
        .exec();

    if (notification === null) {
      throw new NotFoundException();
    }

    return notification;
  }

  async deleteById(id: string): Promise<Notification> {
    const result = await this.notificationModel.findByIdAndDelete(id);

    if (result == null) {
      throw new NotFoundException(`Not found notification with id: ${id}`);
    }

    return result;
  }

  async seed() {
    const ns = await this.notificationModel.find({});
    for (const n of ns) {
      const [r, u] = await Promise.all([
        this.reservationModel.findById(n.reservation),
        this.userModel.findById(n.to_user),
      ]);
      if (!r || !u) {
        await this.notificationModel.deleteOne({ _id: n._id });
        this.logger.debug(`Delete ${n._id}`);
      }
    }
  }
}

declare global {
  interface Array<T> {
    distinct<R = any>(selector?: (t: T) => R): T[]
  }
}

Array.prototype.distinct = function <T, R = any>(this: T[], selector?: (T) => R): T[] {
  selector = selector ?? identity;

  const seen = new Set<R>();
  return this.filter(i => {
    const key = selector(i);
    const added = seen.has(key);

    if (!added) {
      seen.add(key);
    }
    return !added;
  });
};
import { Injectable, Logger } from '@nestjs/common';
import { User } from '../users/user.schema';
import { Reservation } from '../reservations/reservation.schema';
import { InjectModel } from '@nestjs/mongoose';
import * as mongoose from 'mongoose';
import { CreateDocumentDefinition, Model } from 'mongoose';
import { Notification } from './notification.schema';
import { FirebaseMessagingService } from '@aginix/nestjs-firebase-admin';
import * as admin from 'firebase-admin';
import { CreatedReservation } from '../reservations/reservations.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
      @InjectModel(User.name) private readonly userModel: Model<User>,
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Notification.name) private readonly notificationModel: Model<Notification>,
      private readonly firebaseMessagingService: FirebaseMessagingService,
  ) {}

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
        { image: movie.poster_url ?? ''} as Record<string, string>
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
}

declare global {
  interface Array<T> {
    distinct(): T[]
  }
}

Array.prototype.distinct = function <T>(this: T[]): T[] {
  const seen = new Set<T>();
  return this.filter(i => {
    const added = seen.has(i);
    if (!added) {
      seen.add(i);
    }
    return !added;
  });
};
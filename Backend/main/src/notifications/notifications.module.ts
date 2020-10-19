import { Module } from '@nestjs/common';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Notification, NotificationSchema } from './notification.schema';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';
import { User, UserSchema } from '../users/user.schema';
import { Reservation, ReservationSchema } from '../reservations/reservation.schema';
import { Ticket, TicketSchema } from '../seats/ticket.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Notification.name,
        schema: NotificationSchema,
      },
      {
        name: User.name,
        schema: UserSchema,
      },
      {
        name: Reservation.name,
        schema: ReservationSchema,
      },
      {
        name: Ticket.name,
        schema: TicketSchema,
      }
    ]),
    UsersModule,
    ConfigModule,
  ],
  controllers: [NotificationsController],
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {}

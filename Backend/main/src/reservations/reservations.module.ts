import { Module } from '@nestjs/common';
import { ReservationsController, AdminReservationsController } from './reservations.controller';
import { ReservationsService } from './reservations.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Reservation, ReservationSchema } from './reservation.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';
import { Product, ProductSchema } from '../products/product.schema';
import { Ticket, TicketSchema } from '../seats/ticket.schema';
import { SocketModule } from '../socket/socket.module';
import { PromotionsModule } from '../promotions/promotions.module';
import { NotificationsModule } from '../notifications/notifications.module';
import { ShowTime, ShowTimeSchema } from "../show-times/show-time.schema";

@Module({
  imports: [
    SocketModule,
    MongooseModule.forFeature([
      {
        name: Reservation.name,
        schema: ReservationSchema,
      },
      {
        name: Product.name,
        schema: ProductSchema,
      },
      {
        name: Ticket.name,
        schema: TicketSchema,
      },
      {
        name: ShowTime.name,
        schema: ShowTimeSchema,
      }
    ]),
    AuthModule,
    UsersModule,
    ConfigModule,
    PromotionsModule,
    NotificationsModule,
  ],
  controllers: [ReservationsController, AdminReservationsController],
  providers: [ReservationsService]
})
export class ReservationsModule {}

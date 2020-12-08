import { Module } from '@nestjs/common';
import { AdminSeatsController, SeatsController } from './seats.controller';
import { SeatsService } from './seats.service';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { Seat, SeatSchema } from './seat.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';
import { ShowTime, ShowTimeSchema } from '../show-times/show-time.schema';
import { ConfigModule } from '../config/config.module';
import { Ticket, TicketSchema } from './ticket.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Seat.name,
        schema: SeatSchema,
      },
      {
        name: Ticket.name,
        schema: TicketSchema,
      },
      {
        name: Theatre.name,
        schema: TheatreSchema,
      },
      {
        name: ShowTime.name,
        schema: ShowTimeSchema,
      }
    ]),
    AuthModule,
    UsersModule,
    ConfigModule,
  ],
  controllers: [SeatsController, AdminSeatsController],
  providers: [SeatsService],
  exports: [SeatsService],
})
export class SeatsModule {}

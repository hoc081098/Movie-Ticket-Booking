import { Module } from '@nestjs/common';
import { SeatsController } from './seats.controller';
import { SeatsService } from './seats.service';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { Seat, SeatSchema } from './seat.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Seat.name,
        schema: SeatSchema,
      },
      {
        name: Theatre.name,
        schema: TheatreSchema,
      }
    ]),
    AuthModule,
    UsersModule,
  ],
  controllers: [SeatsController],
  providers: [SeatsService]
})
export class SeatsModule {}

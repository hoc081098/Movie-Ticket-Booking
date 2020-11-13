import { Module } from '@nestjs/common';
import { AdminTheatresController, TheatresController } from './theatres.controller';
import { TheatresService } from './theatres.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Theatre, TheatreSchema } from './theatre.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';
import { Seat, SeatSchema } from "../seats/seat.schema";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Theatre.name,
        schema: TheatreSchema,
      },
      {
        name: Seat.name,
        schema: SeatSchema,
      },
    ]),
    AuthModule,
    UsersModule,
    ConfigModule,
  ],
  controllers: [TheatresController, AdminTheatresController],
  providers: [TheatresService]
})
export class TheatresModule {}

import { Module } from '@nestjs/common';
import { TheatresController } from './theatres.controller';
import { TheatresService } from './theatres.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Theatre, TheatreSchema } from './theatre.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Theatre.name,
        schema: TheatreSchema,
      },
    ]),
    AuthModule,
    UsersModule,
  ],
  controllers: [TheatresController],
  providers: [TheatresService]
})
export class TheatresModule {}

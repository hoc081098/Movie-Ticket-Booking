import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from './user.schema';
import { AdminUsersController, UsersController } from './users.controller';
import { ConfigModule } from '../config/config.module';
import { CardsController } from './cards/cards.controller';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: User.name,
        schema: UserSchema,
      }
    ]),
    ConfigModule,
  ],
  providers: [UsersService],
  exports: [UsersService],
  controllers: [UsersController, CardsController, AdminUsersController],
})
export class UsersModule {}

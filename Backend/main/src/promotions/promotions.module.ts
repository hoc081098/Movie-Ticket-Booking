import { Module } from '@nestjs/common';
import { PromotionsController } from './promotions.controller';
import { PromotionsService } from './promotions.service';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';
import { MongooseModule } from '@nestjs/mongoose';
import { Promotion, PromotionSchema } from './promotion.schema';
import { ShowTime, ShowTimeSchema } from '../show-times/show-time.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Promotion.name,
        schema: PromotionSchema,
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
  controllers: [PromotionsController],
  providers: [PromotionsService],
  exports: [PromotionsService],
})
export class PromotionsModule {}

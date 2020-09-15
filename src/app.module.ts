import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from './config/config.module';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigKey, ConfigService } from './config/config.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { FirebaseAdminModule } from '@aginix/nestjs-firebase-admin/dist';
import * as admin from 'firebase-admin';

@Module({
  imports: [
    MongooseModule.forRootAsync(
        {
          imports: [ConfigModule],
          inject: [ConfigService],
          useFactory: (configService: ConfigService) => ({
            uri: configService.get(ConfigKey.MONGODB_URL),
            useFindAndModify: false,
          })
        },
    ),
    FirebaseAdminModule.forRootAsync({
      useFactory: () => ({
        credential: admin.credential.applicationDefault(),
      }),
    }),
    ConfigModule,
    AuthModule,
    UsersModule,
  ],
  controllers: [AppController],
  providers: [
    AppService
  ],
})
export class AppModule {}

import { HttpModule, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from './config/config.module';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigKey, ConfigService } from './config/config.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { FirebaseAdminModule } from '@aginix/nestjs-firebase-admin/dist';
import { MoviesModule } from './movies/movies.module';
import { CategoriesModule } from './categories/categories.module';
import { PeopleModule } from './people/people.module';
import { ShowTimesModule } from './show-times/show-times.module';
import { TheatresModule } from './theatres/theatres.module';
import { CommentsModule } from './comments/comments.module';
import { SeatsModule } from './seats/seats.module';
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
    MoviesModule,
    CategoriesModule,
    PeopleModule,
    ShowTimesModule,
    TheatresModule,
    CommentsModule,
    HttpModule,
    SeatsModule,
  ],
  controllers: [AppController],
  providers: [
    AppService
  ],
})
export class AppModule {}

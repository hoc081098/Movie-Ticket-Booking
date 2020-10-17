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
import { ReservationsModule } from './reservations/reservations.module';
import { PromotionsModule } from './promotions/promotions.module';
import { ProductsModule } from './products/products.module';
import { FavoritesModule } from './favorites/favorites.module';
import * as admin from 'firebase-admin';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { SocketModule } from './socket/socket.module';
import { NotificationsModule } from './notifications/notifications.module';
import { MailerModule } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';

@Module({
  imports: [
    MailerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        return {
          transport: {
            service: 'gmail',
            auth: {
              user: configService.get(ConfigKey.EMAIL),
              pass: configService.get(ConfigKey.EMAIL_PASSWORD),
            },
            secure: false,
            ignoreTLS: true,
          },
          defaults: {
            from: '"Do Not Reply, Cinemas Company 👥" <no-replay@cinemas.com>',
          },
          template: {
            dir: join(__dirname, '..', '..', 'template'),
            adapter: new HandlebarsAdapter(),
            options: {
              strict: true,
            },
          },
        };
      },
    }),
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
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', '..', 'static'),
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
    ReservationsModule,
    PromotionsModule,
    ProductsModule,
    FavoritesModule,
    SocketModule,
    NotificationsModule,
  ],
  controllers: [AppController],
  providers: [
    AppService
  ],
})
export class AppModule {}

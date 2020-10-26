import { HttpModule, Logger, Module } from '@nestjs/common';
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
import { Neo4jModule } from './neo4j/neo4j.module';
import * as dayjs from 'dayjs';
import * as localizedFormat from 'dayjs/plugin/localizedFormat';

dayjs.extend(localizedFormat);

const logger = new Logger('AppModule');

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
          preview: process.env.NODE_ENV !== 'production',
          template: {
            dir: join(__dirname, '..', '..', 'template'),
            adapter: new HandlebarsAdapter({
              formatDate: (date, format) => {
                const formatted = dayjs(date).format(format);
                logger.debug(`formatDate: date=${date} format=${format} -> ${formatted}`);
                return formatted;
              },
              formatCurrency: (currency: number) => {
                const formatted = new Intl.NumberFormat('vi-VN', {
                  style: 'currency',
                  currency: 'VND'
                }).format(currency);
                logger.debug(`formatCurrency: currency=${currency} -> ${formatted}`);
                return formatted;
              },
              orEmpty: (s: string | undefined | null) => s ?? '',
            }),
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
    Neo4jModule,
  ],
  controllers: [AppController],
  providers: [
    AppService
  ],
})
export class AppModule {}

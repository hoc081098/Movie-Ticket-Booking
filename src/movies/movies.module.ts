import { HttpModule, Module } from '@nestjs/common';
import { MoviesService } from './movies.service';
import { AdminMoviesController, MoviesController } from './movies.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Movie, MovieSchema } from './movie.schema';
import { MovieCategory, MovieCategorySchema } from './movie-category.schema';
import { MovieDbService } from './movie-db/movie-db.service';
import { ConfigModule } from '../config/config.module';
import { Category, CategorySchema } from '../categories/category.schema';
import { Person, PersonSchema } from '../people/person.schema';
import { ShowTime, ShowTimeSchema } from '../show-times/show-time.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { Ticket, TicketSchema } from "../seats/ticket.schema";
import { CommentSchema, Comment } from "../comments/comment.schema";
import { Reservation, ReservationSchema } from "../reservations/reservation.schema";
import { Notification, NotificationSchema } from "../notifications/notification.schema";
import { User, UserSchema } from "../users/user.schema";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Movie.name,
        schema: MovieSchema,
      },
      {
        name: MovieCategory.name,
        schema: MovieCategorySchema,
      },
      {
        name: Category.name,
        schema: CategorySchema,
      },
      {
        name: Person.name,
        schema: PersonSchema,
      },
      {
        name: ShowTime.name,
        schema: ShowTimeSchema,
      },
      {
        name: Theatre.name,
        schema: TheatreSchema,
      },
      {
        name: Ticket.name,
        schema: TicketSchema,
      },
      {
        name: Comment.name,
        schema: CommentSchema,
      },
      {
        name: Reservation.name,
        schema: ReservationSchema,
      },
      {
        name: Notification.name,
        schema: NotificationSchema,
      },
      {
        name: User.name,
        schema: UserSchema,
      }
    ]),
    HttpModule,
    ConfigModule,
    AuthModule,
    UsersModule,
    ConfigModule,
  ],
  providers: [MoviesService, MovieDbService],
  controllers: [MoviesController, AdminMoviesController],
  exports: [MoviesService],
})
export class MoviesModule {
}

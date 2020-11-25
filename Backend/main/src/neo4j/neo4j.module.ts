import { Module } from '@nestjs/common';
import { Neo4jService } from './neo4j.service';
import { ConfigModule } from '../config/config.module';
import { Neo4jController } from './neo4j.controller';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '../users/user.schema';
import { Category, CategorySchema } from '../categories/category.schema';
import { Movie, MovieSchema } from '../movies/movie.schema';
import { Comment, CommentSchema } from "../comments/comment.schema";
import { ShowTime, ShowTimeSchema } from 'src/show-times/show-time.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';
import { Reservation, ReservationSchema } from '../reservations/reservation.schema';
import { Person, PersonSchema } from '../people/person.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: User.name,
        schema: UserSchema,
      },
      {
        name: Category.name,
        schema: CategorySchema,
      },
      {
        name: Movie.name,
        schema: MovieSchema,
      },
      {
        name: Comment.name,
        schema: CommentSchema,
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
        name: Reservation.name,
        schema: ReservationSchema,
      },
      {
        name: Person.name,
        schema: PersonSchema,
      },
    ]),
    ConfigModule,
    AuthModule,
    UsersModule,
  ],
  providers: [Neo4jService],
  controllers: [Neo4jController]
})
export class Neo4jModule {}

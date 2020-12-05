import { HttpModule, Module } from '@nestjs/common';
import { CommentsController } from './comments.controller';
import { CommentsService } from './comments.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Comment, CommentSchema } from './comment.schema';
import { Movie, MovieSchema } from '../movies/movie.schema';
import { User, UserSchema } from '../users/user.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';
import { MoviesModule } from '../movies/movies.module';
import { MovieCategory, MovieCategorySchema } from '../movies/movie-category.schema';
import { Category, CategorySchema } from '../categories/category.schema';
import { Person, PersonSchema } from '../people/person.schema';
import { ShowTime, ShowTimeSchema } from '../show-times/show-time.schema';
import { Theatre, TheatreSchema } from '../theatres/theatre.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Comment.name,
        schema: CommentSchema,
      },
      {
        name: Movie.name,
        schema: MovieSchema,
      },
      {
        name: User.name,
        schema: UserSchema,
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
      }
    ]),
    AuthModule,
    UsersModule,
    ConfigModule,
    MoviesModule,
    HttpModule,
  ],
  controllers: [CommentsController],
  providers: [CommentsService]
})
export class CommentsModule {}

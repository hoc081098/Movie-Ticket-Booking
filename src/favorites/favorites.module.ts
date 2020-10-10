import { Module } from '@nestjs/common';
import { FavoritesController } from './favorites.controller';
import { FavoritesService } from './favorites.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Movie, MovieSchema } from '../movies/movie.schema';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Movie.name,
        schema: MovieSchema,
      }
    ]),
    UsersModule,
    ConfigModule,
  ],
  controllers: [FavoritesController],
  providers: [FavoritesService]
})
export class FavoritesModule {}

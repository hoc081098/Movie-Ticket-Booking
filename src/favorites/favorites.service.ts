import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from '../movies/movie.schema';
import { Model } from "mongoose";
import { UserPayload } from '../auth/get-user.decorator';
import { PaginationDto } from '../common/pagination.dto';
import { checkCompletedLogin, getSkipLimit } from '../common/utils';
import * as dayjs from 'dayjs';
import { FavoriteResponse, ToggleFavoriteDto, ToggleFavoriteResponse } from './favorites.dto';
import { UsersService } from '../users/users.service';

@Injectable()
export class FavoritesService {
  private readonly logger = new Logger('FavoritesService');

  constructor(
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
      private readonly usersService: UsersService,
  ) {}

  async getAllFavorites(userPayload: UserPayload, dto: PaginationDto): Promise<Movie[]> {
    const favoriteMovieIds = checkCompletedLogin(userPayload).favorite_movie_ids ?? {};
    const ids = Object.keys(favoriteMovieIds);
    this.logger.debug(`favorite_movie_ids=${ids}`);

    const movies = await this.movieModel.find({ _id: { $in: ids } });
    const sorted = movies.sort((l, r) => {
      const lTime = dayjs(favoriteMovieIds[l._id]);
      const rTime = dayjs(favoriteMovieIds[r._id]);
      return -lTime.diff(rTime, 'millisecond');
    });

    const skipLimit = getSkipLimit(dto);
    return sorted.slice(skipLimit.skip, skipLimit.skip + skipLimit.limit);
  }

  async toggleFavorite(userPayload: UserPayload, dto: ToggleFavoriteDto): Promise<ToggleFavoriteResponse> {
    const { movie_id } = dto;
    const movie = await this.movieModel.findById(movie_id);
    if (!movie) {
      throw new NotFoundException(`Not found movie with id: ${movie_id}`);
    }

    const user = await this.usersService.findByUid(checkCompletedLogin(userPayload).uid);
    const favorite_movie_ids = user.favorite_movie_ids ?? {};

    let is_favorite: boolean;
    if (favorite_movie_ids[movie_id]) {
      delete favorite_movie_ids[movie_id];
      is_favorite = false;
    } else {
      favorite_movie_ids[movie_id] = new Date();
      is_favorite = true;
    }
    await this.usersService.userModel.updateOne({ _id: user._id }, { favorite_movie_ids });
    movie.total_favorite = Math.max(movie.total_favorite + (is_favorite ? 1 : -1), 0);
    await movie.save();

    return new ToggleFavoriteResponse({ movie, is_favorite });
  }

  async checkFavorite(userPayload: UserPayload, movieId: string): Promise<FavoriteResponse> {
    const user = await this.usersService.findByUid(checkCompletedLogin(userPayload).uid);
    const movie = await this.movieModel.findById(movieId);
    if (!movie) {
      throw new NotFoundException(`Not found movie with id: ${movieId}`);
    }

    const is_favorite = !!(user.favorite_movie_ids ?? {})[movieId];
    return new FavoriteResponse({ movie, is_favorite });
  }
}

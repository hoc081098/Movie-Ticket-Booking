import { IsNotEmpty, IsString } from 'class-validator';
import { Movie } from '../movies/movie.schema';

export class ToggleFavoriteDto {
  @IsString()
  @IsNotEmpty()
  readonly movie_id: string;
}

export class ToggleFavoriteResponse {
  readonly movie: Movie;
  readonly is_favorite: boolean;

  constructor(res: { movie: Movie, is_favorite: boolean }) {
    Object.assign(this, res);
  }
}

export class FavoriteResponse {
  readonly movie: Movie;
  readonly is_favorite: boolean;

  constructor(res: { movie: Movie, is_favorite: boolean }) {
    Object.assign(this, res);
  }
}
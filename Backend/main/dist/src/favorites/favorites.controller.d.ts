import { UserPayload } from '../auth/get-user.decorator';
import { PaginationDto } from '../common/pagination.dto';
import { Movie } from '../movies/movie.schema';
import { FavoritesService } from './favorites.service';
import { FavoriteResponse, ToggleFavoriteDto, ToggleFavoriteResponse } from './favorites.dto';
export declare class FavoritesController {
    private readonly favoritesService;
    constructor(favoritesService: FavoritesService);
    checkFavorite(user: UserPayload, movieId: string): Promise<FavoriteResponse>;
    getAllFavorites(user: UserPayload, dto: PaginationDto): Promise<Movie[]>;
    toggleFavorite(user: UserPayload, dto: ToggleFavoriteDto): Promise<ToggleFavoriteResponse>;
}

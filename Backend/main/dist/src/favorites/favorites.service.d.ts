import { Movie } from '../movies/movie.schema';
import { Model } from "mongoose";
import { UserPayload } from '../auth/get-user.decorator';
import { PaginationDto } from '../common/pagination.dto';
import { FavoriteResponse, ToggleFavoriteDto, ToggleFavoriteResponse } from './favorites.dto';
import { UsersService } from '../users/users.service';
export declare class FavoritesService {
    private readonly movieModel;
    private readonly usersService;
    private readonly logger;
    constructor(movieModel: Model<Movie>, usersService: UsersService);
    getAllFavorites(userPayload: UserPayload, dto: PaginationDto): Promise<Movie[]>;
    toggleFavorite(userPayload: UserPayload, dto: ToggleFavoriteDto): Promise<ToggleFavoriteResponse>;
    checkFavorite(userPayload: UserPayload, movieId: string): Promise<FavoriteResponse>;
}

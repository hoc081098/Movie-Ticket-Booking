import { Movie } from '../movies/movie.schema';
export declare class ToggleFavoriteDto {
    readonly movie_id: string;
}
export declare class ToggleFavoriteResponse {
    readonly movie: Movie;
    readonly is_favorite: boolean;
    constructor(res: {
        movie: Movie;
        is_favorite: boolean;
    });
}
export declare class FavoriteResponse {
    readonly movie: Movie;
    readonly is_favorite: boolean;
    constructor(res: {
        movie: Movie;
        is_favorite: boolean;
    });
}

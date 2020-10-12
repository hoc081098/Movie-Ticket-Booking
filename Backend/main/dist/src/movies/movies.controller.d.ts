import { MovieDbService } from './movie-db/movie-db.service';
import { MoviesService } from './movies.service';
import { Movie } from './movie.schema';
import { PaginationDto } from '../common/pagination.dto';
import { GetNowShowingMoviesDto } from './movie.dto';
export declare class MoviesController {
    private readonly movieDbService;
    private readonly moviesService;
    private readonly logger;
    constructor(movieDbService: MovieDbService, moviesService: MoviesService);
    seed({ query, page, year }: {
        query: string;
        page: number;
        year: number;
    }): import("rxjs").Observable<never>;
    updateVideoUrl(): import("rxjs").Observable<void>;
    getNowShowingMovies(dto: GetNowShowingMoviesDto): Promise<Movie[]>;
    getComingSoonMovies(paginationDto: PaginationDto): Promise<Movie[]>;
    getDetail(id: string): Promise<Movie>;
}

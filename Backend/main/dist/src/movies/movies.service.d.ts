import { Movie } from './movie.schema';
import { Model } from 'mongoose';
import { ShowTime } from '../show-times/show-time.schema';
import { Theatre } from '../theatres/theatre.schema';
import { PaginationDto } from '../common/pagination.dto';
export declare class MoviesService {
    private readonly movieModel;
    private readonly showTimeModel;
    private readonly theatreModel;
    private readonly logger;
    constructor(movieModel: Model<Movie>, showTimeModel: Model<ShowTime>, theatreModel: Model<Theatre>);
    all(): Promise<Movie[]>;
    getNowShowingMovies(center: [number, number] | null, paginationDto: PaginationDto): Promise<Movie[]>;
    getComingSoonMovies(paginationDto: PaginationDto): Promise<Movie[]>;
    getDetail(id: string): Promise<Movie>;
}

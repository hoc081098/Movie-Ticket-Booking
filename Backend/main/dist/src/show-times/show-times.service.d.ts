import { ShowTime } from './show-time.schema';
import { Model } from 'mongoose';
import { Movie } from '../movies/movie.schema';
import { Theatre } from '../theatres/theatre.schema';
export declare class ShowTimesService {
    private readonly showTimeModel;
    private readonly movieModel;
    private readonly theatreModel;
    private readonly logger;
    private movieCount;
    constructor(showTimeModel: Model<ShowTime>, movieModel: Model<Movie>, theatreModel: Model<Theatre>);
    seed(): Promise<void>;
    private checkAndSave;
    private randomMovie;
    getShowTimesByMovieId(movieId: string, center: [number, number] | null): Promise<{
        theatre: Theatre;
        show_time: ShowTime;
    }[]>;
}

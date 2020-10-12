import { ShowTimesService } from './show-times.service';
import { MovieAndTheatre } from './show-time.dto';
import { LocationDto } from '../common/location.dto';
export declare class ShowTimesController {
    private readonly showTimesService;
    private readonly logger;
    constructor(showTimesService: ShowTimesService);
    seed(): Promise<void>;
    getShowTimesByMovieId(movieId: string, locationDto: LocationDto): Promise<MovieAndTheatre[]>;
}

import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from './show-time.schema';
export declare class MovieAndTheatre {
    theatre: Theatre;
    show_time: ShowTime;
    constructor(doc: {
        theatre: Theatre;
        show_time: ShowTime;
    });
}

import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from './show-time.schema';
import { Movie } from "../movies/movie.schema";

export class TheatreAndShowTime {
  theatre: Theatre;
  show_time: ShowTime;

  constructor(doc: { theatre: Theatre, show_time: ShowTime }) {
    this.theatre = doc.theatre;
    this.show_time = doc.show_time;
  }
}
export class MovieAndShowTime {
  readonly movie: Movie;
  readonly show_time: ShowTime;

  constructor(doc: { movie: Movie, show_time: ShowTime }) {
    this.movie = doc.movie;
    this.show_time = doc.show_time;
  }
}
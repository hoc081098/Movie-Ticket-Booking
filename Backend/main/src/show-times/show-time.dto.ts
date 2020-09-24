import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from './show-time.schema';

export class MovieAndTheatre {
  theatre: Theatre;
  show_time: ShowTime;

  constructor(doc: {theatre: Theatre, show_time: ShowTime}) {
    this.theatre = doc.theatre;
    this.show_time = doc.show_time;
  }
}
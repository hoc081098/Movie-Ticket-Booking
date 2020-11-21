import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from './show-time.schema';
import { Movie } from "../movies/movie.schema";
import { ArrayMinSize, IsArray, IsDate, IsNotEmpty, IsNumber, IsString, Min, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

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

export class TicketDto {
  @IsString()
  @IsNotEmpty()
  seat: string;

  @Min(0)
  @IsNumber()
  price: number;
}

export class AddShowTimeDto {
  @IsString()
  @IsNotEmpty()
  movie: string;

  @IsString()
  @IsNotEmpty()
  theatre: string;

  @IsDate()
  @Type(() => Date)
  start_time: Date;

  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => TicketDto)
  tickets: TicketDto[];
}
import { LocationDto } from '../common/location.dto';
import { IsDate, IsDateString, IsIn, IsNotEmpty, IsNumber, IsString, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { Movie } from '../movies/movie.schema';

export class SearchMoviesDto extends LocationDto {
  @IsString()
  @IsNotEmpty()
  @Type(() => String)
  query: string;

  @IsDate()
  @Type(() => Date)
  search_start_time: Date;

  @IsDate()
  @Type(() => Date)
  search_end_time: Date;

  @IsDate()
  @Type(() => Date)
  min_released_date: Date;

  @IsDate()
  @Type(() => Date)
  max_released_date: Date;

  @IsNumber()
  @Min(30)
  @Type(() => Number)
  min_duration: number;

  @IsNumber()
  @Min(30)
  @Type(() => Number)
  max_duration: number;

  @IsString()
  @IsIn(['P', 'C13', 'C16', 'C18'])
  age_type: Movie['age_type'];
}
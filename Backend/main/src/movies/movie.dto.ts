import { PaginationDto } from '../common/pagination.dto';
import {
  ArrayMinSize,
  IsArray,
  IsDate,
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min
} from 'class-validator';
import { Type } from 'class-transformer';
import { LatLng } from '../common/utils';

export class GetNowShowingMoviesDto extends PaginationDto implements LatLng {
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  @Type(() => Number)
  lat?: number | null | undefined;

  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  @Type(() => Number)
  lng?: number | null | undefined;
}

export class AddMovieDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  trailer_video_url?: string | null;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  poster_url?: string | null;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  overview?: string | null;

  @IsDate()
  @Type(() => Date)
  released_date: Date;

  @IsNumber()
  @Min(30)
  duration: number;

  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  director_ids: string[];

  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  actor_ids: string[];

  @IsString()
  @IsNotEmpty()
  original_language: string;

  @IsString()
  @IsIn(['P', 'C13', 'C16', 'C18'])
  age_type: 'P' | 'C13' | 'C16' | 'C18';

  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  category_ids: string[];
}
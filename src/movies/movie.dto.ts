import { PaginationDto } from '../common/pagination.dto';
import { IsNumber, IsOptional, Max, Min } from 'class-validator';
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
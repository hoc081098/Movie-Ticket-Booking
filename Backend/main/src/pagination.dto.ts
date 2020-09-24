import { IsNumber, IsOptional, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class PaginationDto {
  @IsOptional()
  @IsNumber()
  @Min(1)
  @Type(() => Number)
  page?: number | null | undefined;

  @IsOptional()
  @IsNumber()
  @Min(1)
  @Type(() => Number)
  per_page?: number | null | undefined;
}
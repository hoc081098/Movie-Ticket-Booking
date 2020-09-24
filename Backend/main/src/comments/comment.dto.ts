import { IsInt, IsNotEmpty, IsNumber, IsString, Max, MaxLength, Min, MinLength } from 'class-validator';

export class CreateCommentDto {
  @IsString()
  @MinLength(20)
  @MaxLength(500)
  content: string;

  @IsNumber()
  @IsInt()
  @Min(1)
  @Max(5)
  rate_star: number;

  @IsString()
  @IsNotEmpty()
  movie_id: string;
}
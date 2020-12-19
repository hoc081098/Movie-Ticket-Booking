import { IsInt, IsNotEmpty, IsNumber, IsString, Max, MaxLength, Min, MinLength } from 'class-validator';
import { Comment } from './comment.schema';

export class CreateCommentDto {
  @IsString()
  @MinLength(10)
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

export class CommentsAndRatingSummary {
  readonly comments: Comment[];
  readonly average: number;
  readonly total: number;

  constructor(comments: Comment[], average: number, total: number) {
    this.comments = comments;
    this.average = average;
    this.total = total;
  }
}
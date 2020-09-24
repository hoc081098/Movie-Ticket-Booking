import { Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Comment } from './comment.schema';
import { AuthGuard } from '../auth/auth.guard';
import { PaginationDto } from '../common/pagination.dto';

@ApiTags('comments')
@UseGuards(AuthGuard)
@Controller('comments')
export class CommentsController {
  constructor(
      private readonly commentsService: CommentsService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed(): Promise<Comment[]> {
    return this.commentsService.seed();
  }

  @Get('/movies/:movie_id')
  getCommentsByMovieId(
      @Param('movie_id')  movieId: string,
      @Query() paginationDto: PaginationDto,
  ): Promise<Comment[]> {
    return this.commentsService.getCommentsByMovieId(
        movieId,
        paginationDto
    );
  }
}

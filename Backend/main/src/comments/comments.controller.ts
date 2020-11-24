import { Body, Controller, Delete, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Comment } from './comment.schema';
import { AuthGuard } from '../auth/auth.guard';
import { PaginationDto } from '../common/pagination.dto';
import { CommentsAndRatingSummary, CreateCommentDto } from './comment.dto';
import { GetUser, UserPayload } from '../auth/get-user.decorator';

@ApiTags('comments')
@UseGuards(AuthGuard)
@Controller('comments')
export class CommentsController {
  constructor(
      private readonly commentsService: CommentsService,
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed() {
    return this.commentsService.seed();
  }

  @Get('/movies/:movie_id')
  getCommentsByMovieId(
      @Param('movie_id')  movieId: string,
      @Query() paginationDto: PaginationDto,
  ): Promise<CommentsAndRatingSummary> {
    return this.commentsService.getCommentsByMovieId(
        movieId,
        paginationDto
    );
  }

  @Post()
  createComment(
      @GetUser() user: UserPayload,
      @Body() createCommentDto: CreateCommentDto,
  ): Promise<Comment> {
    return this.commentsService.createComment(user, createCommentDto);
  }

  @Delete(':id')
  deleteComment(
      @Param('id') id: string,
  ): Promise<Comment> {
    return this.commentsService.deleteComment(id);
  }
}

import { Controller, Post } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Comment } from './comment.schema';

@ApiTags('comments')
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
}

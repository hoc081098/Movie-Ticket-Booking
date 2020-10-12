import { CommentsService } from './comments.service';
import { Comment } from './comment.schema';
import { PaginationDto } from '../common/pagination.dto';
import { CommentsAndRatingSummary, CreateCommentDto } from './comment.dto';
import { UserPayload } from '../auth/get-user.decorator';
export declare class CommentsController {
    private readonly commentsService;
    constructor(commentsService: CommentsService);
    seed(): Promise<Comment[]>;
    getCommentsByMovieId(movieId: string, paginationDto: PaginationDto): Promise<CommentsAndRatingSummary>;
    createComment(user: UserPayload, createCommentDto: CreateCommentDto): Promise<Comment>;
    deleteComment(id: string): Promise<Comment>;
}

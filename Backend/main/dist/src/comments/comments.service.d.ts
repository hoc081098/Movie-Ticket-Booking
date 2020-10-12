import { Model } from 'mongoose';
import { Comment } from './comment.schema';
import { Movie } from '../movies/movie.schema';
import { User } from '../users/user.schema';
import { PaginationDto } from '../common/pagination.dto';
import { CommentsAndRatingSummary, CreateCommentDto } from './comment.dto';
import { UserPayload } from '../auth/get-user.decorator';
export declare class CommentsService {
    private readonly commentModel;
    private readonly movieModel;
    private readonly userModel;
    private readonly logger;
    constructor(commentModel: Model<Comment>, movieModel: Model<Movie>, userModel: Model<User>);
    seed(): Promise<Comment[]>;
    getCommentsByMovieId(movieId: string, paginationDto: PaginationDto): Promise<CommentsAndRatingSummary>;
    createComment(user: UserPayload, dto: CreateCommentDto): Promise<Comment>;
    deleteComment(id: string): Promise<Comment>;
}

import { Comment } from './comment.schema';
export declare class CreateCommentDto {
    content: string;
    rate_star: number;
    movie_id: string;
}
export declare class CommentsAndRatingSummary {
    readonly comments: Comment[];
    readonly average: number;
    readonly total: number;
    constructor(comments: Comment[], average: number, total: number);
}

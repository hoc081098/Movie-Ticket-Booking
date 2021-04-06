import '../../domain/model/comment.dart';
import '../../domain/model/comments.dart';
import '../../domain/repository/comment_repository.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/comment_response.dart';
import '../remote/response/comments_response.dart';

class CommentRepositoryImpl implements CommentRepository {
  final AuthHttpClient _authClient;
  final Function1<CommentsResponse, Comments> _commentsResponseToComments;
  final Function1<CommentResponse, Comment> _commentResponseToComment;

  CommentRepositoryImpl(
    this._authClient,
    this._commentsResponseToComments,
    this._commentResponseToComment,
  );

  @override
  Stream<Comments> getComments({
    required String movieId,
    required int page,
    required int perPage,
  }) async* {
    ArgumentError.checkNotNull(movieId, 'movieId');
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(perPage, 'perPage');

    final json = await _authClient.getJson(
      buildUrl(
        '/comments/movies/$movieId',
        {
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
      ),
    );

    yield _commentsResponseToComments(CommentsResponse.fromJson(json));
  }

  @override
  Stream<void> removeCommentById(String id) async* {
    ArgumentError.checkNotNull(id, 'id');
    await _authClient.deleteJson(buildUrl('/comments/$id'));
    yield null;
  }

  @override
  Stream<Comment> addComment({
    required String content,
    required int rateStar,
    required String movieId,
  }) async* {
    ArgumentError.checkNotNull(content, 'content');
    ArgumentError.checkNotNull(rateStar, 'rateStar');
    ArgumentError.checkNotNull(movieId, 'movieId');

    if (rateStar < 1 || 5 < rateStar) {
      throw ArgumentError.value(
        rateStar,
        'rateStar',
        'must be in range from 1 to 5',
      );
    }
    if (content.length < 10 || content.length > 500) {
      throw ArgumentError.value(
        content,
        'content',
        'length must be in range from 10 to 500',
      );
    }

    final body = <String, dynamic>{
      'content': content,
      'rate_star': rateStar,
      'movie_id': movieId,
    };
    final json = await _authClient.postJson(
      buildUrl('/comments'),
      body: body,
    );

    yield _commentResponseToComment(CommentResponse.fromJson(json));
  }
}

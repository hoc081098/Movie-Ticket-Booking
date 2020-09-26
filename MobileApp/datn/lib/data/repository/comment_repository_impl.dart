import '../../domain/model/comments.dart';
import '../../domain/repository/comment_repository.dart';
import '../../utils/type_defs.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/comments_response.dart';

class CommentRepositoryImpl implements CommentRepository {
  final AuthClient _authClient;
  final Function1<CommentsResponse, Comments> _commentsResponseToComments;

  CommentRepositoryImpl(
    this._authClient,
    this._commentsResponseToComments,
  );

  @override
  Stream<Comments> getComments({String movieId, int page, int perPage}) async* {
    ArgumentError.checkNotNull(movieId, 'movieId');
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(perPage, 'perPage');

    final json = await _authClient.getBody(
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
}

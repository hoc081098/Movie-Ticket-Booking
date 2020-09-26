import 'package:meta/meta.dart';

import '../model/comments.dart';

abstract class CommentRepository {
  Stream<Comments> getComments({
    @required String movieId,
    @required int page,
    @required int perPage,
  });

  Stream<void> removeCommentById(String id);
}

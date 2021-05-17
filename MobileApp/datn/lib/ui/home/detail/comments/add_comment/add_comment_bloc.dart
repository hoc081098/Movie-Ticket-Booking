import 'dart:async';

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../../../domain/model/comment.dart';
import '../../../../../domain/repository/comment_repository.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/utils.dart';

@immutable
@sealed
abstract class Message {}

class AddCommentSuccessMessage implements Message {
  final Comment comment;

  AddCommentSuccessMessage(this.comment);
}

class AddCommentFailureMessage implements Message {
  final Object error;

  AddCommentFailureMessage(this.error);
}

class AddCommentBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> rateChanged;
  final Function1<String, void> contentChanged;
  final Function0<void> submit;

  final Stream<Message> message$;
  final ValueStream<Tuple2<bool, String?>> isLoadingContentError$;

  AddCommentBloc._({
    required void Function() dispose,
    required this.rateChanged,
    required this.contentChanged,
    required this.isLoadingContentError$,
    required this.submit,
    required this.message$,
  }) : super(dispose);

  factory AddCommentBloc(
    final CommentRepository commentRepository,
    final String movieId,
  ) {
    final rateS = BehaviorSubject.seeded(5);
    final contentS = PublishSubject<String>();
    final submitS = PublishSubject<void>();
    final isLoadingS = BehaviorSubject.seeded(false);

    final contentError$ = contentS
        .map(
          (s) => Tuple2(
            s,
            s.length < 10 || s.length > 500
                ? S.current.lengthOfContentMustBeInFrom10To500
                : null,
          ),
        )
        .publish();

    final message$ = submitS
        .withLatestFrom(
          contentError$,
          (_, Tuple2<String, String?> tuple) => tuple,
        )
        .where((tuple) => tuple.item2 == null)
        .map((tuple) => tuple.item1)
        .withLatestFrom(
          rateS,
          (String content, int rate) => Tuple2(content, rate),
        )
        .exhaustMap(
          (tuple) => commentRepository
              .addComment(
                content: tuple.item1,
                rateStar: tuple.item2,
                movieId: movieId,
              )
              .doOnError((e, s) => print('$e $s'))
              .doOnListen(() => isLoadingS.add(true))
              .doOnEach((_) => isLoadingS.add(false))
              .map<Message>((added) => AddCommentSuccessMessage(added))
              .onErrorReturnWith((error, s) => AddCommentFailureMessage(error)),
        )
        .publish();

    final isLoadingContentError$ = Rx.combineLatest2(
      isLoadingS,
      contentError$.map((tuple) => tuple.item2),
      (bool b, String? s) => Tuple2(b, s),
    ).publishValueSeeded(Tuple2(false, null));

    final subscriptions = [
      contentError$.connect(),
      message$.connect(),
      isLoadingContentError$.connect(),
    ];

    return AddCommentBloc._(
      dispose: () async {
        await Future.wait(subscriptions.map((e) => e.cancel()));
        await Future.wait(
          <StreamController>[
            rateS,
            contentS,
            isLoadingS,
            submitS,
          ].map((e) => e.close()),
        );
      },
      //
      rateChanged: rateS.add,
      contentChanged: contentS.add,
      submit: () => submitS.add(null),
      //
      isLoadingContentError$: isLoadingContentError$,
      message$: message$,
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tuple/tuple.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utils/utils.dart';
import '../../../../app_scaffold.dart';
import 'add_comment_bloc.dart';

class AddCommentPage extends StatefulWidget {
  static const routeName = '/home/detail/comments/add';

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> with DisposeBagMixin {
  Object? token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token ??= BlocProvider.of<AddCommentBloc>(context)
        .message$
        .listen(handleMessage)
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddCommentBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addComment),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            RatingBar.builder(
              initialRating: 5,
              itemCount: 5,
              allowHalfRating: false,
              minRating: 1,
              itemSize: 54,
              onRatingUpdate: (v) => bloc.rateChanged(v.toInt()),
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                );
                // switch (index) {
                //   case 0:
                //     return Icon(
                //       Icons.sentiment_very_dissatisfied,
                //       color: Colors.red,
                //     );
                //   case 1:
                //     return Icon(
                //       Icons.sentiment_dissatisfied,
                //       color: Colors.redAccent,
                //     );
                //   case 2:
                //     return Icon(
                //       Icons.sentiment_neutral,
                //       color: Colors.amber,
                //     );
                //   case 3:
                //     return Icon(
                //       Icons.sentiment_satisfied,
                //       color: Colors.lightGreen,
                //     );
                //   case 4:
                //     return Icon(
                //       Icons.sentiment_very_satisfied,
                //       color: Colors.green,
                //     );
                // }
                // throw StateError('$index');
              },
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RxStreamBuilder<Tuple2<bool, String?>>(
                stream: bloc.isLoadingContentError$,
                builder: (context, tuple) {
                  if (tuple.item1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return TextField(
                    minLines: 1,
                    maxLines: 10,
                    maxLength: 500,
                    onChanged: bloc.contentChanged,
                    decoration: InputDecoration(
                      hintText: S.of(context).yourComment,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(width: 0.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      errorText: tuple.item2,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bloc.submit,
        child: Transform.rotate(
          angle: -pi / 8,
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  void handleMessage(Message message) async {
    if (message is AddCommentSuccessMessage) {
      context.showSnackBar(S.of(context).addCommentSuccessfully);
      await delay(500);
      AppScaffold.navigatorOfCurrentIndex(context).pop(message.comment);
      return;
    }
    if (message is AddCommentFailureMessage) {
      context.showSnackBar(
        S.of(context).addCommentFailureMessage(getErrorMessage(message.error)),
      );
    }
  }
}

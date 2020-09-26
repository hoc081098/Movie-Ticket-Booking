import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';

import '../../../../domain/model/comment.dart';
import '../../../../domain/repository/comment_repository.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import 'action.dart';
import 'state.dart' as st;
import 'store.dart';

class CommentsPage extends StatefulWidget {
  final String movieId;

  const CommentsPage({Key key, @required this.movieId}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with DisposeBagMixin {
  RxReduxStore<Action, st.State> store;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    store ??= () {
      final commentRepository = Provider.of<CommentRepository>(context);

      final getComments = ({
        @required int page,
        @required int perPage,
      }) =>
          commentRepository.getComments(
            movieId: widget.movieId,
            page: page,
            perPage: perPage,
          );

      final store = createStore(getComments);
      subscribe(store);
      store.dispatch(const LoadFirstPageAction());
      return store;
    }();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void subscribe(RxReduxStore<Action, st.State> store) {
    store.stateStream
        .listen((state) => print('Page: ${state.page}'))
        .disposedBy(bag);

    store.actionStream.listen((action) {
      if (action is FailureAction) {
        context.showSnackBar(
          'Error occurred: ${getErrorMessage(action.error)}',
        );
      }
      if (action is SuccessAction) {
        if (action.comments.comments.isEmpty) {
          context.showSnackBar('Loaded all comments');
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            color: Theme.of(context).accentColor,
          ),
        ),
        Expanded(
          child: StreamBuilder<st.State>(
            stream: store.stateStream,
            initialData: store.state,
            builder: (context, snapshot) {
              final state = snapshot.data;

              if (state.isLoading && state.isFirstPage) {
                return Center(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: LoadingIndicator(
                      color: Theme.of(context).accentColor,
                      indicatorType: Indicator.ballScaleMultiple,
                    ),
                  ),
                );
              }

              if (state.error != null && state.isFirstPage) {
                return MyErrorWidget(
                  errorText: 'Error: ${getErrorMessage(state.error)}',
                  onPressed: () => store.dispatch(const RetryAction()),
                );
              }

              if (state.items.isEmpty) {
                return Center(
                  child: EmptyWidget(
                    message: 'Empty comments',
                  ),
                );
              }

              return CommentItemsListWidget(
                state: state,
                dispatch: store.dispatch,
              );
            },
          ),
        ),
      ],
    );
  }
}

class CommentItemsListWidget extends StatelessWidget {
  const CommentItemsListWidget({
    Key key,
    @required this.state,
    @required this.dispatch,
  }) : super(key: key);

  final st.State state;
  final void Function(Action) dispatch;

  @override
  Widget build(BuildContext context) {
    final items = state.items;

    return ListView.separated(
      itemCount: items.length + (state.isFirstPage ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];
          return RepoItemWidget(item: item);
        }

        if (state.error != null) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: MyErrorWidget(
              errorText:
                  'Load page ${state.page}, error: ${getErrorMessage(state.error)}',
              onPressed: () => dispatch(const RetryAction()),
            ),
          );
        }

        if (state.isLoading) {
          return Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: LoadingIndicator(
                color: Theme.of(context).accentColor,
                indicatorType: Indicator.ballScaleMultiple,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Center(
            child: SizedBox(
              width: 128,
              height: 48,
              child: RaisedButton(
                onPressed: () => dispatch(const LoadNextPageAction()),
                child: Text('Next page'),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class RepoItemWidget extends StatelessWidget {
  const RepoItemWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Comment item;

  @override
  Widget build(BuildContext context) {
    final imageSize = 64.0;

    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  offset: Offset(2, 2),
                  color: Colors.grey.shade300,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipOval(
              child: item.user.avatar == null
                  ? Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: imageSize * 0.7,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: item.user.avatar,
                      fit: BoxFit.cover,
                      width: imageSize,
                      height: imageSize,
                      progressIndicatorBuilder: (
                        BuildContext context,
                        String url,
                        progress,
                      ) {
                        return Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      },
                      errorWidget: (
                        BuildContext context,
                        String url,
                        dynamic error,
                      ) {
                        return Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: imageSize * 0.7,
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.user.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 17),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item.content * 3,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 14),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

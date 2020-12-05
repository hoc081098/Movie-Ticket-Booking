import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/model/theatre.dart';
import '../../domain/repository/theatres_repository.dart';
import '../../ui/app_scaffold.dart';
import '../../ui/show_times/show_times_page.dart';
import '../../utils/error.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'add/add_theatre_page.dart';
import 'theatre_info_page.dart';

class TheatresPage extends StatefulWidget {
  static const routeName = '/home/theatres';
  final bool showTime;

  const TheatresPage({Key key, this.showTime = false}) : super(key: key);

  @override
  _TheatresPageState createState() => _TheatresPageState();
}

class _TheatresPageState extends State<TheatresPage> {
  LoaderBloc<List<Theatre>> bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (bloc == null) {
      final loaderFunction = () =>
          Rx.fromCallable(Provider.of<TheatresRepository>(context).getTheatres);
      bloc = LoaderBloc(
        loaderFunction: loaderFunction,
        refresherFunction: loaderFunction,
        enableLogger: true,
      )..fetch();
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theatres'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: RxStreamBuilder<LoaderState<List<Theatre>>>(
          stream: bloc.state$,
          builder: (context, snapshot) {
            final state = snapshot.data;

            if (state.isLoading) {
              return Center(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: LoadingIndicator(
                    color: Theme.of(context).accentColor,
                    indicatorType: Indicator.ballClipRotatePulse,
                  ),
                ),
              );
            }

            if (state.error != null) {
              return Center(
                child: MyErrorWidget(
                  errorText: 'Error: ${getErrorMessage(state.error)}',
                  onPressed: bloc.fetch,
                ),
              );
            }

            final items = state.content;

            if (items.isEmpty) {
              return Center(
                child: EmptyWidget(
                  message: 'Empty theatre',
                ),
              );
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Card(
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (widget.showTime) {
                          AppScaffold.of(context).pushNamed(
                            ShowTimesPage.routeName,
                            arguments: item,
                          );
                        } else {
                          AppScaffold.of(context).pushNamed(
                            TheatreInfoPage.routeName,
                            arguments: item,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                item.thumbnail ?? '',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            fontSize: 14,
                                            color: const Color(0xff5B64CF)),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.address,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontSize: 11),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: widget.showTime
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () async {
                final added = await AppScaffold.of(context).pushNamed(
                  AddTheatrePage.routeName,
                );
                if (added != null) {
                  await bloc.refresh();
                }
              },
              child: Icon(Icons.add),
            ),
    );
  }
}

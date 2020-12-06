import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../domain/model/show_time.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/show_times_repository.dart';
import '../../ui/app_scaffold.dart';
import '../../ui/show_times/select_movie_page.dart';
import '../../ui/widgets/empty_widget.dart';
import '../../ui/widgets/error_widget.dart';
import '../../utils/error.dart';
import 'list_item.dart';

class ShowTimesPage extends StatefulWidget {
  static const routeName = '/home/show-times';

  final Theatre theatre;

  const ShowTimesPage({Key key, @required this.theatre}) : super(key: key);

  @override
  _ShowTimesPageState createState() => _ShowTimesPageState();
}

class _ShowTimesPageState extends State<ShowTimesPage> {
  var isLoading = true;
  var page = 0;
  var loadedAll = false;
  List<ShowTime> list;
  Object error;

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (list == null) {
      final showTimesRepository = Provider.of<ShowTimesRepository>(context);

      showTimesRepository
          .getShowTimesByTheatreId(widget.theatre.id, 1, 16)
          .then((value) {
        if (mounted) {
          setState(() {
            list = value;
            isLoading = false;
            error = null;
            page = 1;
          });
        }
      }).catchError((e, s) {
        if (mounted) {
          setState(() {
            isLoading = false;
            error = e;
          });
        }
      });

      controller.addListener(() async {
        if (controller.hasClients &&
            controller.offset + 56 * 2 >= controller.position.maxScrollExtent &&
            !isLoading &&
            error == null &&
            list.isNotEmpty &&
            page > 0 &&
            !loadedAll) {
          if (mounted) {
            setState(() {
              isLoading = true;
              error = null;
            });
          } else {
            return;
          }

          final newItems = await showTimesRepository.getShowTimesByTheatreId(
            widget.theatre.id,
            page + 1,
            16,
          );

          if (mounted) {
            setState(() {
              list = [...list, ...newItems];
              isLoading = false;
              error = null;
              if (newItems.isNotEmpty) {
                page++;
              }
              loadedAll = newItems.isEmpty;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theatre.name),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppScaffold.of(context).pushNamed(
            SelectMoviePage.routeName,
            arguments: widget.theatre,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    if (list == null || (isLoading && page == 0)) {
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

    if (error != null && page == 0) {
      return Center(
        child: MyErrorWidget(
          errorText: 'Error: ${getErrorMessage(error)}',
          onPressed: () {},
        ),
      );
    }

    if (list.isEmpty) {
      return Center(
        child: EmptyWidget(
          message: 'Empty show time',
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      itemCount: list.length + (page == 0 ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < list.length) {
          return ShowTimeItem(
            item: list[index],
            theatre: widget.theatre,
          );
        }

        if (error != null) {
          return Center(
            child: MyErrorWidget(
              errorText: 'Error: ${getErrorMessage(error)}',
              onPressed: () {},
            ),
          );
        }

        if (isLoading) {
          return SizedBox(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (loadedAll) {
          return const SizedBox(width: 0, height: 0);
        }

        return const SizedBox(height: 56);
      },
    );
  }
}

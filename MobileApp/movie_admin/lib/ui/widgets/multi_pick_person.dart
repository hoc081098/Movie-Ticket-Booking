import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_scaffold.dart';
import '../movies/upload_movie/movie_upload_bloc.dart';
import '../movies/upload_movie/movie_upload_page.dart';
import '../../domain/model/person.dart';

class MultiPickPersonWidget extends StatefulWidget {
  static final String routeName = 'MultiPickPersonWidget';
  final MovieUploadBloc bloc;

  MultiPickPersonWidget(this.bloc);

  @override
  _MultiPickPersonState createState() => _MultiPickPersonState();
}

class _MultiPickPersonState extends State<MultiPickPersonWidget> {
  final key = GlobalKey();
  final searchController = TextEditingController();
  List<Person> listPersonChoices = List.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchController
        .addListener(() => widget.bloc.loadPerson(searchController.text));
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchView(),
        Expanded(child: _buildListView()),
        _buildButton(context)
      ],
    );
  }

  Widget _buildSearchView() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            maxLines: 1,
            maxLength: 100,
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.all(5.0),
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                searchController.text = '';
              });
            })
      ],
    );
  }

  Widget _buildListView() {
    return StreamBuilder<List<Person>>(
        stream: widget.bloc.showSearch$,
        builder: (context, snapshot) {
          final listData = snapshot.data ?? List.empty();
          print('length list ' + listData.length.toString());
          return ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      if (listPersonChoices.contains(listData[index])) {
                        listPersonChoices.remove(listData[index]);
                      } else {
                        listPersonChoices.add(listData[index]);
                      }
                    });
                  },
                  tileColor: listPersonChoices.contains(listData[index])
                      ? Colors.deepPurple
                      : Colors.black,
                  leading: _buildAvatar(60, context, listData[index]),
                  title: Text(listData[index].full_name),
                  trailing: listPersonChoices.contains(listData[index])
                      ? Icon(Icons.check, color: Colors.deepPurple)
                      : SizedBox(width: 0),
                );
              });
        });
  }

  Widget _buildAvatar(double imageSize, BuildContext context, Person person) {
    return Container(
      width: imageSize,
      height: imageSize,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0.0, 1.0),
            color: Colors.grey.shade500,
            spreadRadius: 1,
          )
        ],
      ),
      child: ClipOval(
        child: person.avatar == null
            ? Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: imageSize * 0.7,
                ),
              )
            : CachedNetworkImage(
                imageUrl: person.avatar,
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
    );
  }

  Widget _buildButton(BuildContext context) {
    return Row(
      children: [
        RaisedButton(
            child: Text('Pick person choice'),
            onPressed: () {
              AppScaffold.of(context).popAndPushNamed(
                UploadMoviePage.routeName,
                arguments: listPersonChoices,
              );
            })
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/model/person.dart';
import '../../utils/type_defs.dart';
import '../movies/upload_movie/movie_upload_bloc.dart';

class MultiPickPersonWidget extends StatefulWidget {
  static final String routeName = 'MultiPickPersonWidget';
  final MovieUploadBloc bloc;
  final Function1<List<Person>, void> onPickPerson;

  MultiPickPersonWidget({@required this.bloc, @required this.onPickPerson});

  @override
  _MultiPickPersonState createState() => _MultiPickPersonState();
}

class _MultiPickPersonState extends State<MultiPickPersonWidget> {
  final key = GlobalKey();
  final searchController = TextEditingController();
  List<Person> listPersonChoices = <Person>[];

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
        _buildButton(context),
      ],
    );
  }

  Widget _buildSearchView() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              maxLines: 1,
              maxLength: 100,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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
              }),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return StreamBuilder<List<Person>>(
        stream: widget.bloc.showSearch$,
        initialData: <Person>[],
        builder: (context, snapshot) {
          final listData = snapshot.data;
          return listData == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    final isContain =
                        listPersonChoices.contains(listData[index]);
                    return ListTile(
                      onTap: () {
                        setState(() {
                          if (isContain) {
                            listPersonChoices.remove(listData[index]);
                          } else {
                            listPersonChoices.add(listData[index]);
                          }
                        });
                      },
                      tileColor: Colors.white,
                      leading: _buildAvatar(40, context, listData[index]),
                      title: Text(listData[index].full_name),
                      trailing: isContain
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
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 50),
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.all(10),
            child: Text(
              'Pick person choice',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              widget.onPickPerson(listPersonChoices.toList());
              listPersonChoices.clear();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(
                color: Colors.blueAccent,
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            color: Colors.white,
          ),
        ),
        SizedBox(width: 50),
      ],
    );
  }
}

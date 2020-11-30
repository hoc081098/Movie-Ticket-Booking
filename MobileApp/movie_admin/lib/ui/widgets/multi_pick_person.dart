import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import '../../domain/model/person.dart';
import '../../domain/repository/movie_repository.dart';

class MultiPickPersonWidget extends StatefulWidget {
  final String url;

  MultiPickPersonWidget(this.url);

  @override
  _MultiPickPersonState createState() => _MultiPickPersonState();
}

class _MultiPickPersonState extends State<MultiPickPersonWidget> {
  final key = GlobalKey();
  MovieRepository repository;
  final searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final a = context;
    repository = Provider.of<MovieRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Movie'),
      ),
      body: Column(
        children: [
          _buildSearchView(),
          _buildListView(),
        ],
      ),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
}

Widget _buildListView() {
  return StreamBuilder<List<Person>>(builder: (context, snapshot) {
    final listData = snapshot.data ?? List.empty();
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (cotext, index) {
          return ListTile(
            leading: _buildAvatar(60, context, listData[index]),
            title: Text(listData[index].full_name),
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

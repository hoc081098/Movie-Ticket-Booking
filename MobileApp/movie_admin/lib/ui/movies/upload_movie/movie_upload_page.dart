import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../domain/model/category.dart';
import '../../../utils/utils.dart';
import '../../../domain/model/age_type.dart';

import '../../app_scaffold.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/multi_pick_person.dart';
import 'movie_upload_bloc.dart';
import 'movie_upload_input.dart';

class UploadMoviePage extends StatefulWidget {
  static const routeName = '/upload_movie_route';

  @override
  _UploadMoviePageState createState() => _UploadMoviePageState();
}

class _UploadMoviePageState extends State<UploadMoviePage>
    with DisposeBagMixin {
  final releasedDateFormat = DateFormat.yMMMd();
  final key = GlobalKey<ScaffoldState>();
  _RowTextType showSearch;
  final controllers = {
    _RowTextType.TITLE: TextEditingController(),
    _RowTextType.ORIGIN_LANG: TextEditingController(),
    _RowTextType.OVERVIEW: TextEditingController(),
    _RowTextType.DURATION: TextEditingController(),
    _RowTextType.RELEASED_DAY: TextEditingController(),
  };
  MovieUploadInput movieUploadInput = MovieUploadInput.init();

  MovieUploadBloc bloc;
  Object listen;

  @override
  void didChangeDependencies() {
    bloc ??= BlocProvider.of<MovieUploadBloc>(context);
    listen ??= bloc.error$.listen((event) {
      key.showSnackBar('Error ${getErrorMessage(event)}');
    }).disposedBy(bag);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controllers.values.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Movie'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              showSearch != null
                  ? showSearch = null
                  : AppScaffold.of(context).pop();
            });
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (showSearch != null) {
            setState(() {
              showSearch = null;
            });
            return false;
          }
          return true;
        },
        child: showSearch != null
            ? MultiPickPersonWidget(
                bloc: bloc,
                onPickPerson: (persons) {
                  if (showSearch == _RowTextType.DIRECTOR) {
                    movieUploadInput.directors = persons;
                  } else {
                    movieUploadInput.actors = persons;
                  }
                  setState(() {
                    showSearch = null;
                  });
                })
            : ListView(
                children: _RowTextType.values
                    .map((e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: _typeToWidget(
                                e,
                              ) ??
                              Text('11111'),
                        ))
                    .toList(),
              ),
      ),
    );
  }

  Widget _buildTextRow({
    @required String textTitle,
    @required String textHint,
    @required TextEditingController controller,
    int maxLines,
    TextInputType textInputType,
  }) {
    return Row(
      crossAxisAlignment: maxLines == null || maxLines == 1
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            textTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: 200,
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType ?? TextInputType.text,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
                hintText: textHint,
                border: maxLines == null || maxLines == 1
                    ? UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8))
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildUrlOption({
    @required String title,
    @required UrlType typeUrl,
  }) {
    final isPoster = title == 'Poster url: ';
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: typeUrl == UrlType.FILE
              ? RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.deepPurpleAccent)),
                  elevation: 3,
                  onPressed: () async {
                    final imagePicker = ImagePicker();
                    if (isPoster) {
                      final image = await imagePicker.getImage(
                        source: ImageSource.gallery,
                        maxWidth: 720,
                        maxHeight: 720,
                      );
                      if (image == null) return;
                      movieUploadInput.posterFile = File(image.path);
                    } else {
                      final video = await imagePicker.getVideo(
                          source: ImageSource.gallery,
                          maxDuration: Duration(minutes: 30));
                      if (video == null) return;
                      movieUploadInput.trailerFile = File(video.path);
                    }
                    setState(() {});
                  },
                  child: Text(
                    isPoster
                        ? movieUploadInput.posterFile?.toString() ?? 'Empty'
                        : movieUploadInput.trailerFile?.toString() ?? 'Empty',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                )
              : TextFormField(
                  initialValue: isPoster
                      ? movieUploadInput.posterUrl
                      : movieUploadInput.trailerVideoUrl,
                  onChanged: (value) => isPoster
                      ? movieUploadInput.posterUrl = value
                      : movieUploadInput.trailerVideoUrl = value,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: 'Url',
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
        ),
        SizedBox(width: 5),
        PopupMenuButton<UrlType>(
            child: Row(
              children: [
                Text(
                  typeUrl.toString().split('.')[1],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            onSelected: (e) {
              if (isPoster) {
                movieUploadInput.posterType = e;
              } else {
                movieUploadInput.trailerType = e;
              }
              setState(() {});
            },
            itemBuilder: (context) => UrlType.values
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    child: Text(
                      e.toString().split('.')[1],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList()),
        SizedBox(width: 5),
      ],
    );
  }

  Widget _buildReleasedDayTextField() {
    return Row(
      children: [
        SizedBox(width: 10),
        Text(
          'Released day: ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: DateTimeField(
            initialValue: movieUploadInput.releasedDate,
            format: releasedDateFormat,
            readOnly: true,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
                selectableDayPredicate: (date) => date.isAfter(DateTime(1990)),
              );
            },
            validator: (date) {
              if (date == null) {
                return null;
              }
              return date.isBefore(DateTime(1990))
                  ? 'Invalid released date'
                  : null;
            },
            onChanged: (v) => movieUploadInput.releasedDate = v,
            resetIcon: Icon(Icons.delete, color: Colors.deepPurpleAccent),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: Icon(
                  Icons.date_range,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              labelText: 'Released date',
              labelStyle: TextStyle(color: Colors.black54),
              fillColor: Colors.deepPurpleAccent,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent)),
            ),
          ),
        ),
        SizedBox(width: 20)
      ],
    );
  }

  Widget _buildChoiceSearch(_RowTextType type) {
    final length = type == _RowTextType.ACTOR
        ? movieUploadInput.actors.length
        : movieUploadInput.directors.length;
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            type == _RowTextType.ACTOR ? 'Actor: ' : 'Director: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        RaisedButton(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.deepPurpleAccent)),
          onPressed: () {
            setState(() {
              showSearch = type;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: length == 0
                ? Text('Search...')
                : Text(
                    length.toString() +
                        (type == _RowTextType.ACTOR ? ' Actors' : ' Directors'),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _typeToWidget(_RowTextType e) {
    switch (e) {
      case _RowTextType.TITLE:
        return _buildTextRow(
          textTitle: 'Title: ',
          textHint: 'Enter title',
          controller: controllers[e],
        );
      case _RowTextType.OVERVIEW:
        return _buildTextRow(
          textTitle: 'Overview: ',
          textHint: 'Enter overview',
          maxLines: 5,
          controller: controllers[e],
        );
      case _RowTextType.DURATION:
        return _buildTextRow(
          textTitle: 'Duration: ',
          textHint: 'Enter duration',
          controller: controllers[e],
          textInputType: TextInputType.number,
        );
      case _RowTextType.ORIGIN_LANG:
        return _buildTextRow(
          textTitle: 'Language: ',
          controller: controllers[e],
          textHint: 'Enter language',
        );
      case _RowTextType.RELEASED_DAY:
        return _buildReleasedDayTextField();
      case _RowTextType.TRAILER_URL:
        return _buildUrlOption(
          title: 'Trailer url: ',
          typeUrl: movieUploadInput.trailerType,
        );
      case _RowTextType.POSTER_URL:
        return _buildUrlOption(
          title: 'Poster url: ',
          typeUrl: movieUploadInput.posterType,
        );
      case _RowTextType.AGE_TYPE:
        return _buildAgeType();
      case _RowTextType.CATEGORY:
        return _buildChoiceCategory();
      case _RowTextType.DIRECTOR:
      case _RowTextType.ACTOR:
        return _buildChoiceSearch(e);
      case _RowTextType.BUTTON_UPLOAD:
        return StreamBuilder<ButtonState>(
            stream: bloc.stateStream$,
            builder: (context, snapshot) {
              if (snapshot.data == ButtonState.success) {
                AppScaffold.of(context).pop();
              }
              return _buildLoadingButton(snapshot.data ?? ButtonState.idle);
            });
      default:
        return Center(child: Text('Error'));
    }
  }

  Widget _buildLoadingButton(ButtonState state) {
    return Row(
      children: [
        SizedBox(
          width: 32,
        ),
        Expanded(
          child: ProgressButton.icon(
            iconedButtons: {
              ButtonState.idle: IconedButton(
                  text: 'ADD',
                  icon: Icon(Icons.update, color: Colors.white),
                  color: Colors.deepPurple.shade500),
              ButtonState.loading: IconedButton(
                  text: 'Loading', color: Colors.deepPurple.shade700),
              ButtonState.fail: IconedButton(
                  text: 'Failed',
                  icon: Icon(Icons.cancel, color: Colors.white),
                  color: Colors.red.shade300),
              ButtonState.success: IconedButton(
                  text: 'Success',
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  color: Colors.green.shade400)
            },
            onPressed: () {
              print('cliced');
              updateDataForInput();
              print('cliced2');

              print('############' + movieUploadInput.toString());
              bloc.uploadMovie(movieUploadInput);
            },
            state: state,
          ),
        ),
        SizedBox(
          width: 32,
        ),
      ],
    );
  }

  Widget _buildChoiceCategory() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            'Category: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        RaisedButton(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.deepPurpleAccent)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Country List'),
                    content: _PickCategoryWidget(
                      bloc: bloc,
                      onSelectedCategory: (listCategory) {
                        setState(() {
                          movieUploadInput.categorys = listCategory;
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  );
                });
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: movieUploadInput.categorys.isEmpty
                ? Text('Pick...')
                : Text(movieUploadInput.categorys.length.toString() +
                    ' categories'),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildAgeType() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            'Age type',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: 200,
          child: PopupMenuButton<AgeType>(
              child: Row(
                children: [
                  Text(
                    movieUploadInput.ageType.toString().split('.')[1],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              onSelected: (e) {
                setState(() {
                  movieUploadInput.ageType = e;
                });
              },
              itemBuilder: (context) => AgeType.values
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(
                        e.toString().split('.')[1],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList()),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  void updateDataForInput() {
    movieUploadInput.title = controllers[_RowTextType.TITLE].text;
    movieUploadInput.overview = controllers[_RowTextType.OVERVIEW].text;
    movieUploadInput.duration =
        int.tryParse(controllers[_RowTextType.DURATION].text);
    movieUploadInput.originalLanguage =
        controllers[_RowTextType.ORIGIN_LANG].text;
  }
}

enum _RowTextType {
  TITLE,
  OVERVIEW,
  DURATION,
  RELEASED_DAY,
  TRAILER_URL,
  POSTER_URL,
  AGE_TYPE,
  CATEGORY,
  DIRECTOR,
  ACTOR,
  ORIGIN_LANG,
  BUTTON_UPLOAD
}

class _PickCategoryWidget extends StatefulWidget {
  final MovieUploadBloc bloc;
  final Function1<List<Category>, void> onSelectedCategory;

  const _PickCategoryWidget({
    Key key,
    @required this.bloc,
    @required this.onSelectedCategory,
  }) : super(key: key);

  @override
  _PickCategoryState createState() => _PickCategoryState();
}

class _PickCategoryState extends State<_PickCategoryWidget> {
  final listCategoryChoices = <Category>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: StreamBuilder<List<Category>>(
        stream: widget.bloc.fetchCategory$,
        builder: (context, snapshot) {
          final listData = snapshot.data ?? List.empty();
          return Column(
            children: <Widget>[
              buildListView(listData),
              SizedBox(height: 10),
              _buildButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget buildListView(List<Category> listData) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                listCategoryChoices.contains(listData[index])
                    ? listCategoryChoices.remove(listData[index])
                    : listCategoryChoices.add(listData[index]);
              });
            },
            child: Container(
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                listData[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: listCategoryChoices.contains(listData[index])
                      ? Colors.blue
                      : Colors.black,
                ),
              ),
              decoration: ShapeDecoration(
                color: listCategoryChoices.contains(listData[index])
                    ? Colors.lightBlueAccent.withOpacity(0.15)
                    : Colors.black.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    width: 1,
                    color: listCategoryChoices.contains(listData[index])
                        ? Colors.deepPurple.withOpacity(0.4)
                        : Colors.white,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          );
        },
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
              'Pick category',
              style: TextStyle(fontSize: 14),
            ),
            onPressed: () =>
                widget.onSelectedCategory(listCategoryChoices.toList()),
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

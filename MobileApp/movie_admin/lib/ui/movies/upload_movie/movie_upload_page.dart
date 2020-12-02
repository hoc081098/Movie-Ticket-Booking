import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../domain/model/age_type.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/person.dart';
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

class _UploadMoviePageState extends State<UploadMoviePage> {
  final releasedDateFormat = DateFormat.yMMMd();
  DateTime releasedDay = DateTime(2020);
  final key = GlobalKey();
  bool showSearch = false;
  final controllers = {
    _RowTextType.TITLE: TextEditingController(),
    _RowTextType.ORIGIN_LANG: TextEditingController(),
    _RowTextType.OVERVIEW: TextEditingController(),
    _RowTextType.DURATION: TextEditingController(),
    _RowTextType.POSTER_URL: TextEditingController(),
    _RowTextType.TRAILER_URL: TextEditingController(),
    _RowTextType.RELEASED_DAY: TextEditingController(),
  };
  MovieUploadInput movieUploadInput = MovieUploadInput.init();

  MovieUploadBloc bloc;

  @override
  void didChangeDependencies() {
    bloc ??= BlocProvider.of<MovieUploadBloc>(context);
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
              showSearch ? showSearch = false : AppScaffold.of(context).pop();
            });
          },
        ),
      ),
      body: showSearch
          ? MultiPickPersonWidget(bloc)
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
    @required TextEditingController controller,
    @required UrlType typeUrl,
  }) {
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
                    if (title == 'Poster url: ') {
                      final image = await imagePicker.getImage(
                        source: ImageSource.gallery,
                        maxWidth: 720,
                        maxHeight: 720,
                      );
                      bloc.posterUrl(Tuple2(typeUrl, image.path));
                    } else {
                      final video = await imagePicker.getVideo(
                          source: ImageSource.gallery,
                          maxDuration: Duration(minutes: 30));
                      bloc.trailerUrl(Tuple2(typeUrl, video.path));
                    }
                  },
                  child: Text(
                    controller.text.isEmpty ? 'Empty' : controller.text,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                )
              : TextFormField(
                  controller: controller,
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
              if (title == 'Poster url: ') {
                bloc.posterUrl(Tuple2(e, ''));
              } else {
                bloc.trailerUrl(Tuple2(e, ''));
              }
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
            format: releasedDateFormat,
            readOnly: true,
            controller: controllers[_RowTextType.RELEASED_DAY],
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
            onChanged: (v) => releasedDay = v,
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
              showSearch = true;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: length == 0
                ? Text('Search...')
                : Text(length.toString() + ' person'),
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
        return StreamBuilder<Tuple2<UrlType, String>>(
          stream: bloc.trailerUrlStream$,
          builder: (context, snapshot) {
            controllers[e].text = snapshot.data?.item2 ?? '';
            return _buildUrlOption(
              title: 'Trailer url: ',
              controller: controllers[e],
              typeUrl: snapshot.data?.item1 ?? UrlType.FILE,
            );
          },
        );
      case _RowTextType.POSTER_URL:
        return StreamBuilder<Tuple2<UrlType, String>>(
          stream: bloc.posterUrlStream$,
          builder: (context, snapshot) {
            controllers[e].text = snapshot.data?.item2 ?? '';
            return _buildUrlOption(
              title: 'Poster url: ',
              controller: controllers[e],
              typeUrl: snapshot.data?.item1 ?? UrlType.FILE,
            );
          },
        );
      case _RowTextType.AGE_TYPE:
        return _buildAgeType();
      case _RowTextType.DIRECTOR:
      case _RowTextType.ACTOR:
      case _RowTextType.CATEGORY:
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
              movieUploadInput.title = controllers[_RowTextType.TITLE].text;
              movieUploadInput.overview =
                  controllers[_RowTextType.OVERVIEW].text;
              movieUploadInput.releasedDate =
                  controllers[_RowTextType.RELEASED_DAY].text;
              movieUploadInput.posterUrl =
                  controllers[_RowTextType.POSTER_URL].text;
              movieUploadInput.trailerVideoUrl =
                  controllers[_RowTextType.TRAILER_URL].text;
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
}

enum _RowTextType {
  TITLE,
  OVERVIEW,
  DURATION,
  RELEASED_DAY,
  TRAILER_URL,
  POSTER_URL,
  AGE_TYPE,
  DIRECTOR,
  ACTOR,
  ORIGIN_LANG,
  CATEGORY,
  BUTTON_UPLOAD
}

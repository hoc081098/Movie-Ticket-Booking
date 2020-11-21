import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/repository/movie_repository.dart';
import '../../widgets/loading_button.dart';
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
  final controllers = {
    _RowTextType.TITLE: TextEditingController(),
    _RowTextType.ORIGIN_LANG: TextEditingController(),
    _RowTextType.OVERVIEW: TextEditingController(),
    _RowTextType.DURATION: TextEditingController(),
    _RowTextType.POSTER_URL: TextEditingController(),
    _RowTextType.TRAILER_URL: TextEditingController(),
    _RowTextType.RELEASED_DAY: TextEditingController(),
  };

  MovieUploadBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = MovieUploadBloc(Provider.of<MovieRepository>(context));
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
      ),
      body: StreamBuilder<MovieUploadInput>(
        initialData: MovieUploadInput.init(),
        builder: (context, snapshot) {
          return ListView(
            children: _RowTextType.values
                .map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: _typeToWidget(e) ?? Text('11111'),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  void updateForState(MovieUploadInput state) {
    controllers[_RowTextType.TITLE].text = state.title;
    controllers[_RowTextType.ORIGIN_LANG].text = state.originalLanguage;
    controllers[_RowTextType.OVERVIEW].text = state.overview;
    controllers[_RowTextType.DURATION].text = state.duration.toString();
    controllers[_RowTextType.POSTER_URL].text = state.posterUrl;
    controllers[_RowTextType.TRAILER_URL].text = state.trailerVideoUrl;
    controllers[_RowTextType.RELEASED_DAY].text =
        state.releasedDate.toIso8601String();
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
                      );
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
            onSelected: (e) => title == 'Poster url: '
                ? bloc.posterUrl(Tuple2(typeUrl, ''))
                : bloc.trailerUrl(Tuple2(typeUrl, '')),
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
        Text(
          'Released day: ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          'Pick date',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.black,
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
        DateTimeField(
          format: releasedDateFormat,
          readOnly: true,
          controller: controllers[_RowTextType.RELEASED_DAY],
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),
              selectableDayPredicate: (date) => date.isBefore(DateTime.now()),
            );
          },
          validator: (date) {
            if (date == null) {
              return null;
            }
            return date.isAfter(DateTime.now())
                ? 'Invalid released date'
                : null;
          },
          onChanged: (v) => releasedDay = v,
          resetIcon: Icon(Icons.delete, color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(
                Icons.date_range,
                color: Colors.white,
              ),
            ),
            labelText: 'Released date',
            labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceSearch(_RowTextType type) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            type == _RowTextType.CATEGORY
                ? 'Category: '
                : type == _RowTextType.ACTOR
                    ? 'Actor: '
                    : 'Director: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        RaisedButton(
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<String>(
              items: ['', '1', '13', '14'],
              searchLabel: 'Search people',
              suggestion: Center(
                child: Text('Filter people by name, surname or age'),
              ),
              failure: Center(
                child: Text('No person found :('),
              ),
              filter: (person) => [person],
              builder: (person) => ListTile(
                title: Text('12345'),
              ),
            ),
          ),
          child: Text(
            '',
            style: TextStyle(
              backgroundColor: Colors.black12,
              decoration: TextDecoration.overline,
              color: Colors.black,
              fontSize: 15,
              fontStyle: FontStyle.italic,
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
        return null;
      case _RowTextType.TRAILER_URL:
        return StreamBuilder<Tuple2<UrlType, String>>(
          builder: (context, snapshot) {
            controllers[e].text = snapshot.data.item2;
            return _buildUrlOption(
              title: 'Trailer url: ',
              controller: controllers[e],
              typeUrl: null,
            );
          },
        );
      case _RowTextType.POSTER_URL:
        return StreamBuilder<Tuple2<UrlType, String>>(
          builder: (context, snapshot) {
            controllers[e].text = snapshot.data.item2;
            return _buildUrlOption(
              title: 'Poster url: ',
              controller: controllers[e],
              typeUrl: snapshot.data.item1,
            );
          },
        );
      case _RowTextType.AGE_TYPE:
        return Text('');
      case _RowTextType.DIRECTOR:
      case _RowTextType.ACTOR:
      case _RowTextType.CATEGORY:
        return _buildChoiceSearch(e);
      case _RowTextType.BUTTON_UPLOAD:
        return _buildLoadingButton(ButtonState.idle);
      default:
        return Center(child: Text('Error'));
    }
  }

  Widget _buildLoadingButton(ButtonState state) {
    return ProgressButton.icon(
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: 'Update',
            icon: Icon(Icons.update, color: Colors.white),
            color: Colors.deepPurple.shade500),
        ButtonState.loading:
            IconedButton(text: 'Loading', color: Colors.deepPurple.shade700),
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
      onPressed: () => bloc.uploadMovie(null),
      state: state,
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
  DIRECTOR,
  ACTOR,
  ORIGIN_LANG,
  AGE_TYPE,
  CATEGORY,
  BUTTON_UPLOAD
}

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';

class UploadMoviePage extends StatefulWidget {
  static const routeName = '/upload_movie_route';

  @override
  _UploadMoviePageState createState() => _UploadMoviePageState();
}

class _UploadMoviePageState extends State<UploadMoviePage> {
  final releasedDateFormat = DateFormat.yMMMd();
  final releasedTextController = TextEditingController();
  DateTime releasedDay = DateTime(2020);
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Movie'),
      ),
      body: ListView(
        children: _RowTextType.values
            .map((e) => _typeToWidget(e) ?? Text('11111'))
            .toList(),
      ),
    );
  }

  Widget _buildTextRow({
    @required String textTitle,
    @required String textHint,
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
      ],
    );
  }

  Widget _buildUrlOption({@required String title}) {
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
          child: Text(
            'Choice file',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        PopupMenuButton<_UrlType>(
            child: Row(
              children: [
                Text(
                  'Choice file',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            onSelected: (_) {},
            itemBuilder: (context) => _UrlType.values
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    child: Text(
                      e == _UrlType.FILE ? 'From file' : 'From url',
                      style: TextStyle(
                        decoration: TextDecoration.overline,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                )
                .toList()),
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
          controller: releasedTextController,
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
        );
      case _RowTextType.OVERVIEW:
        return _buildTextRow(
          textTitle: 'Overview: ',
          textHint: 'Enter overview',
          maxLines: 5,
        );
      case _RowTextType.DURATION:
        return _buildTextRow(
          textTitle: 'Duration: ',
          textHint: 'Enter duration',
          textInputType: TextInputType.number,
        );
      case _RowTextType.ORIGIN_LANG:
        return _buildTextRow(
          textTitle: 'Language: ',
          textHint: 'Enter language',
        );
      case _RowTextType.RELEASED_DAY:
        return null;
      case _RowTextType.TRAILER_URL:
        return _buildUrlOption(title: 'Trailer url: ');
      case _RowTextType.POSTER_URL:
        return _buildUrlOption(title: 'Poster url: ');
      case _RowTextType.AGE_TYPE:
        return Text('');
      case _RowTextType.DIRECTOR:
      case _RowTextType.ACTOR:
      case _RowTextType.CATEGORY:
        return _buildChoiceSearch(e);
      default:
        return Center(child: Text('Error'));
    }
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
  CATEGORY
}
enum _UrlType { URL, FILE }

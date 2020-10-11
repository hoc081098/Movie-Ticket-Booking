import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final String errorText;
  final void Function() onPressed;

  const MyErrorWidget({
    Key key,
    @required this.errorText,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          errorText,
          style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 15),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: RaisedButton(
            child: Text('Retry'),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 32,
            ),
            onPressed: onPressed,
            color: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

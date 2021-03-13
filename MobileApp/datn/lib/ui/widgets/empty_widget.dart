import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(56),
          child: Container(
            height: 112,
            width: 112,
            child: Center(
              child: Icon(
                Icons.inbox,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class DarkEmptyWidget extends StatelessWidget {
  const DarkEmptyWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: const Color(0xff0ed3f9),
          borderRadius: BorderRadius.circular(56),
          child: Container(
            height: 112,
            width: 112,
            child: Center(
              child: Icon(
                Icons.inbox,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}

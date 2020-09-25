DateTime startOfDay(DateTime d) {
  return DateTime(d.year, d.month, d.day, 0, 0, 0, 0, 0);
}

String weekdayOf(DateTime d) {
  final weekday = d.weekday;
  switch (weekday) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
  }
  throw StateError('Unknown $weekday');
}

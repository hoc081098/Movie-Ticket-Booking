import '../model/theatre.dart';

abstract class TheatresRepository {
  Future<List<Theatre>> getTheatres();
}

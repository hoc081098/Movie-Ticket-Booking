import 'package:meta/meta.dart';
import 'package:movie_admin/domain/model/movie.dart';

class ShowTime {
  final bool isActive;
  final String id;
  final Movie movie;
  final String movieId;
  final String theatreId;
  final String room;
  final DateTime endTime;
  final DateTime startTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShowTime({
    @required this.isActive,
    @required this.id,
    @required this.movie,
    @required this.movieId,
    @required this.theatreId,
    @required this.room,
    @required this.endTime,
    @required this.startTime,
    @required this.createdAt,
    @required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowTime &&
          runtimeType == other.runtimeType &&
          isActive == other.isActive &&
          id == other.id &&
          movie == other.movie &&
          movieId == other.movieId &&
          theatreId == other.theatreId &&
          room == other.room &&
          endTime == other.endTime &&
          startTime == other.startTime &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      isActive.hashCode ^
      id.hashCode ^
      movie.hashCode ^
      movieId.hashCode ^
      theatreId.hashCode ^
      room.hashCode ^
      endTime.hashCode ^
      startTime.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() => 'ShowTime{isActive: $isActive, id: $id, movie: $movie,'
      ' movieId: $movieId, theatreId: $theatreId, room: $room, endTime: $endTime'
      ', startTime: $startTime, createdAt: $createdAt, updatedAt: $updatedAt}';
}

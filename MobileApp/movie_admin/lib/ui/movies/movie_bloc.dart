import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import '../../utils/utils.dart';

class MovieBloc extends DisposeCallbackBaseBloc {
  MovieBloc._({
    @required Function0<void> dispose,
  }) : super(dispose);

  factory MovieBloc() => MovieBloc._(dispose: DisposeBag([]).dispose);
}

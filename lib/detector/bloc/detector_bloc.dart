import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'detector_event.dart';
part 'detector_state.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  DetectorBloc() : super(DetectorInitial());

  @override
  Stream<DetectorState> mapEventToState(
    DetectorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

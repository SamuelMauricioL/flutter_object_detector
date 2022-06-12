import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:object_detector/detector/models/result_model.dart';

part 'detector_event.dart';
part 'detector_state.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  DetectorBloc() : super(DetectorLoading()) {
    on<SelectDetectedObject>(_onDetectObjects);
  }

  Future<void> _onDetectObjects(
    SelectDetectedObject event,
    Emitter emit,
  ) async {
    emit(DetectorLoaded(result: event.object));
  }
}

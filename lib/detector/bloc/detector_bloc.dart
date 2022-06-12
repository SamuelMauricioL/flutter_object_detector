import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:object_detector/detector/models/result_model.dart';
import 'package:tflite/tflite.dart';

part 'detector_event.dart';
part 'detector_state.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  DetectorBloc() : super(DetectorLoading()) {
    on<LoadModel>(_onLoadModel);
    on<SelectDetectedObject>(_onDetectObjects);
  }

  Future<void> _onLoadModel(
    LoadModel event,
    Emitter emit,
  ) async {
    await Tflite.loadModel(
      model: 'assets/ssd_mobilenet_v2.tflite',
      labels: 'assets/ssd_mobilenet_v2.txt',
    );
    emit(DetectorLoading());
  }

  Future<void> _onDetectObjects(
    SelectDetectedObject event,
    Emitter emit,
  ) async {
    emit(DetectorLoaded(result: event.object));
  }
}

part of 'detector_bloc.dart';

abstract class DetectorEvent extends Equatable {
  const DetectorEvent();

  @override
  List<Object> get props => [];
}

class SelectDetectedObject extends DetectorEvent {
  const SelectDetectedObject({
    required this.object,
  });

  final ResultModel object;
}

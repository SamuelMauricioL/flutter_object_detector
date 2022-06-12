part of 'detector_bloc.dart';

abstract class DetectorState extends Equatable {
  const DetectorState();

  @override
  List<Object> get props => [];
}

class DetectorLoading extends DetectorState {
  final ResultModel result = ResultModel.empty();

  @override
  List<Object> get props => [result];
}

class DetectorLoaded extends DetectorState {
  const DetectorLoaded({required this.result});
  final ResultModel result;

  @override
  List<Object> get props => [result];
}

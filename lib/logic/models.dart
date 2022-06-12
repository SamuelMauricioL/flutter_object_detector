// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

ResultModel resultModelFromJson(String str) =>
    ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  ResultModel({
    required this.rect,
    required this.accuracy,
    required this.detectedClass,
  });
  factory ResultModel.fromJson(dynamic json) {
    final accuracy = double.parse(json['confidenceInClass'].toString());
    return ResultModel(
      rect: Rect.fromJson(json['rect']),
      accuracy: (accuracy * 100).round(),
      detectedClass: json['detectedClass'].toString(),
    );
  }

  factory ResultModel.empty() {
    return ResultModel(
      rect: Rect(w: 1, x: 1, h: 1, y: 1),
      accuracy: 0,
      detectedClass: '...',
    );
  }

  Rect rect;
  int accuracy;
  String detectedClass;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'rect': rect.toJson(),
        'accuracy': accuracy,
        'detectedClass': detectedClass,
      };
}

class Rect {
  Rect({
    required this.w,
    required this.x,
    required this.h,
    required this.y,
  });
  factory Rect.fromJson(dynamic json) => Rect(
        w: double.parse(json['w'].toString()),
        x: double.parse(json['x'].toString()),
        h: double.parse(json['h'].toString()),
        y: double.parse(json['y'].toString()),
      );

  final double w;
  final double x;
  final double h;
  final double y;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'w': w,
        'x': x,
        'h': h,
        'y': y,
      };
}

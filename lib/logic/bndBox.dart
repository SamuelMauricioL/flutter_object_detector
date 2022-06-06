// ignore_for_file: avoid_dynamic_calls, avoid_print

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:object_detector/logic/colors_theme.dart';
import 'package:object_detector/logic/models.dart';

class BndBox extends StatelessWidget {
  const BndBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
  );

  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      return results.map((dynamic re) {
        final resultModel = ResultModel.fromJson(re);
        final rect = resultModel.rect;
        final detectedClass = resultModel.detectedClass;
        final accuracy = resultModel.accuracy;
        print('===========> ${resultModel.toJson()}');

        final _x = rect.x;
        final _w = rect.w;
        final _y = rect.y;
        final _h = rect.h;
        double scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          final difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          final difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: const EdgeInsets.only(top: 5, left: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
                width: 3,
              ),
            ),
            child: Text(
              '$detectedClass $accuracy%',
              style: const TextStyle(
                color: secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: _renderBoxes(),
    );
  }
}

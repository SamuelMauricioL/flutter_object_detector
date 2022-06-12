// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:object_detector/logic/camera.dart';
import 'package:object_detector/logic/colors_theme.dart';
import 'package:object_detector/logic/models.dart';
import 'package:tflite/tflite.dart';

class DetectorPage extends StatefulWidget {
  const DetectorPage();

  @override
  State<DetectorPage> createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  bool canRecognize = false;

  String objectsSend = '';

  ResultModel _resultModel = ResultModel.empty();

  Future<void> loadModel() async {
    setState(() {
      canRecognize = true;
    });
    await Tflite.loadModel(
      model: 'assets/ssd_mobilenet_v2.tflite',
      labels: 'assets/ssd_mobilenet_v2.txt',
    );
  }

  void setRecognitions(
    ResultModel resultModel,
  ) {
    setState(() {
      _resultModel = resultModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !canRecognize
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async => loadModel(),
                      child: const Text('Real Time Detection'),
                    ),
                  ],
                ),
              )
            : Stack(
                children: <Widget>[
                  Camera(setRecognitions: setRecognitions),
                  FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 0.13,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topCenter,
                      color: primaryColorTransparent,
                      child: Text(
                        'Detectado ${_resultModel.detectedClass}',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

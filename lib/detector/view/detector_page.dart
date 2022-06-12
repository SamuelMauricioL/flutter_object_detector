// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:object_detector/detector/components/camera.dart';
import 'package:object_detector/detector/models/result_model.dart';
import 'package:tflite/tflite.dart';

class DetectorPage extends StatefulWidget {
  const DetectorPage();

  static Page page() {
    return const MaterialPage<void>(
      child: DetectorPage(),
    );
  }

  @override
  State<DetectorPage> createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  ResultModel _resultModel = ResultModel.empty();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadModel();
    });
    super.initState();
  }

  Future<void> _loadModel() async {
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
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            '🤖 ${_resultModel.detectedClass} 📷',
            style: const TextStyle(color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
        body: CameraCustom(setRecognitions: setRecognitions),
      ),
    );
  }
}

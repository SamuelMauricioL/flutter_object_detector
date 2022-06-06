// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:object_detector/logic/bndBox.dart';
import 'package:object_detector/logic/camera.dart';
import 'package:object_detector/logic/colors_theme.dart';
import 'package:tflite/tflite.dart';

class DetectorPage extends StatefulWidget {
  const DetectorPage();

  @override
  State<DetectorPage> createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  bool canRecognize = false;

  String objectsSend = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

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
    List<dynamic> recognitions,
    int imageHeight,
    int imageWidth,
  ) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
          : SafeArea(
              child: Stack(
                children: <Widget>[
                  Camera(setRecognitions: setRecognitions),
                  BndBox(
                    _recognitions ?? List<dynamic>.empty(),
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 0.13,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topCenter,
                      color: primaryColorTransparent,
                      child: Text(
                        'Detectado ${_objectDetected(_recognitions.toString())}',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _createButom(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _createButom() {
    return SizedBox(
      width: 255,
      child: ElevatedButton(
        child: const Text('Send'),
        onPressed: () async {
          _showInSnackBar(objectsSend);
        },
      ),
    );
  }

  String _objectDetected(String object) {
    try {
      if (object == '[]' || object == '') return 'vacio';
      final primero = object.split('detectedClass')[1];
      final segundo = primero.split('}')[0];
      final tercero = segundo.split(' ')[1];
      objectsSend = tercero;
      print('Objeto detectado: $objectsSend');
      return objectsSend;
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _showInSnackBar(String object) {
    final snackBar = SnackBar(
      content: Text('Se envió a $object'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}

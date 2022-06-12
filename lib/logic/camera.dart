// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detector/logic/models.dart';
import 'package:tflite/tflite.dart';

typedef Callback = void Function(ResultModel list);

class Camera extends StatefulWidget {
  const Camera({
    Key? key,
    required this.setRecognitions,
  }) : super(key: key);

  final Callback setRecognitions;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? _cameraController;
  bool isDetecting = false;

  // inicializando camara
  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Asegurar que el widget se haya montado
      if (!mounted) return;
      setState(() {});

      // Inicializando el controller
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _cameraController!.startImageStream(
          (CameraImage img) async {
            if (isDetecting) return;
            isDetecting = true;

            final recognitions = await Tflite.detectObjectOnFrame(
              bytesList: img.planes.map((plane) => plane.bytes).toList(),
              imageHeight: img.width,
              imageWidth: img.height,
              numResultsPerClass: 3,
              threshold: 0.4,
            );
            print('===========> ${img.height} - ${img.width} || $recognitions');
            if (recognitions != null && recognitions.isNotEmpty) {
              widget.setRecognitions(ResultModel.fromJson(recognitions[0]));
            }
            isDetecting = false;
          },
        ).onError((error, stackTrace) {
          print('ERROR: $error || stackTrace: $stackTrace');
        });
      });
    } on CameraException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.description}');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initCamera();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    var tmp = MediaQuery.of(context).size;
    final screenH = math.max(tmp.height, tmp.width);
    final screenW = math.min(tmp.height, tmp.width);
    tmp = _cameraController!.value.previewSize!;
    final previewH = math.max(tmp.height, tmp.width);
    final previewW = math.min(tmp.height, tmp.width);
    final screenRatio = screenH / screenW;
    final previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(_cameraController!),
    );
  }
}

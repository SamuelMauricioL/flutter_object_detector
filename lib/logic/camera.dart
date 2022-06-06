// ignore_for_file: avoid_print

import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

typedef Callback = void Function(List<dynamic> list, int h, int w);

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
  CameraController? controller;
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
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      setState(() {
        controller!.startImageStream(
          (CameraImage img) async {
            if (isDetecting) return;
            isDetecting = true;

            final recognitions = await Tflite.detectObjectOnFrame(
              bytesList: img.planes.map((plane) => plane.bytes).toList(),
              imageHeight: img.width,
              imageWidth: img.height,
              // rotation: 90,
              numResultsPerClass: 3,
              threshold: 0.4,
            );
            print('===========> ${img.height} - ${img.width} || $recognitions');

            // final recognitions = await Tflite.detectObjectOnFrame(
            //   bytesList: img.planes.map((plane) => plane.bytes).toList(),
            //   model: 'YOLO',
            //   imageMean: 0,
            //   imageStd: 255,
            //   threshold: 0.3, // defaults to 0.1
            //   numResultsPerClass: 2, // defaults to 5
            // );
            widget.setRecognitions(
              recognitions!,
              img.height,
              img.width,
            );
            isDetecting = false;
          },
        );
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
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    final screenH = math.max(tmp.height, tmp.width);
    final screenW = math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize!;
    final previewH = math.max(tmp.height, tmp.width);
    final previewW = math.min(tmp.height, tmp.width);
    final screenRatio = screenH / screenW;
    final previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!),
    );
  }
}

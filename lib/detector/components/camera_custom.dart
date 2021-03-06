// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detector/detector/models/result_model.dart';
import 'package:tflite/tflite.dart';

typedef Callback = void Function(ResultModel resultModel);

class CameraCustom extends StatefulWidget {
  const CameraCustom({
    Key? key,
    required this.setRecognitions,
  }) : super(key: key);

  final Callback setRecognitions;

  @override
  State<CameraCustom> createState() => _CameraCustomState();
}

class _CameraCustomState extends State<CameraCustom> {
  CameraController? _cameraController;
  bool isDetecting = false;

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
              imageHeight: img.width, // 480
              imageWidth: img.height, // 720
              numResultsPerClass: 1,
              threshold: 0.4,
            );
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
    return CameraPreview(_cameraController!);
  }
}

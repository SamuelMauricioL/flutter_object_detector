// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_detector/detector/bloc/detector_bloc.dart';
import 'package:object_detector/detector/components/camera.dart';
import 'package:tflite/tflite.dart';

class DetectorPage extends StatelessWidget {
  const DetectorPage({Key? key}) : super(key: key);

  static Page page() {
    return const MaterialPage<void>(
      child: DetectorPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetectorBloc(),
      child: const DetectorView(),
    );
  }
}

class DetectorView extends StatefulWidget {
  const DetectorView();

  @override
  State<DetectorView> createState() => _DetectorViewState();
}

class _DetectorViewState extends State<DetectorView> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: BlocBuilder<DetectorBloc, DetectorState>(
            builder: (_, state) {
              if (state is DetectorLoading) {
                return const Text(
                  '🤖 ... 📷',
                  style: TextStyle(color: Colors.black87),
                  textAlign: TextAlign.center,
                );
              }
              if (state is DetectorLoaded) {
                return Text(
                  '🤖 ${state.result.detectedClass} 📷',
                  style: const TextStyle(color: Colors.black87),
                  textAlign: TextAlign.center,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        body: CameraCustom(
          setRecognitions: (object) {
            context
                .read<DetectorBloc>()
                .add(SelectDetectedObject(object: object));
          },
        ),
      ),
    );
  }
}

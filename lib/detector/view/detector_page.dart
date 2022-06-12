// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_detector/detector/bloc/detector_bloc.dart';
import 'package:object_detector/detector/components/camera.dart';

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
      create: (_) => DetectorBloc()..add(LoadModel()),
      child: DetectorView(),
    );
  }
}

class DetectorView extends StatelessWidget {
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

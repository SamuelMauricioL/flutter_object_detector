import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_detector/detector/bloc/detector_bloc.dart';
import 'package:object_detector/detector/components/camera_custom.dart';

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
      child: const DetectorView(),
    );
  }
}

class DetectorView extends StatelessWidget {
  const DetectorView({Key? key}) : super(key: key);

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

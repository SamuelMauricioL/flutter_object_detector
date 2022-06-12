import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_detector/app/bloc/app_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() {
    return const MaterialPage<void>(
      child: HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                const toDetector = AppPageChangedTo(
                  page: AppPageStatus.detector,
                );
                context.read<AppBloc>().add(toDetector);
              },
              child: const Text('Real Time Detection'),
            ),
          ],
        ),
      ),
    );
  }
}

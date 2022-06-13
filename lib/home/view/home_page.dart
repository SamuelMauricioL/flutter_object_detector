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

  static String tfImage =
      'https://imgs.search.brave.com/t4QoHy_Dp2Vbqc539qlOgRt_i58hrKh6ANIb97qDFOw/rs:fit:960:536:1/g:ce/aHR0cHM6Ly9zcGVj/aWFscy1pbWFnZXMu/Zm9yYmVzaW1nLmNv/bS9pbWFnZXNlcnZl/LzVmYzA5Y2YxOTUw/MTc5YTNmNWY3NDg3/NC85NjB4MC5qcGc_/Zml0PXNjYWxl';

  static String flutterImage =
      'https://imgs.search.brave.com/5qDql1Jd_J7Zr1Jo2ivgi1a6y0MLci7LIoWH8Y0OQLI/rs:fit:1124:533:1/g:ce/aHR0cHM6Ly90ZWNo/LnBlbG1vcmV4LmNv/bS93cC1jb250ZW50/L3VwbG9hZHMvMjAy/MC8xMC9mbHV0dGVy/LnBuZw';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(tfImage, fit: BoxFit.fill),
            const SizedBox(height: 20),
            const Text('+', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 20),
            Image.network(flutterImage, fit: BoxFit.fill),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      const toDetector = AppPageChangedTo(
                        page: AppPageStatus.detector,
                      );
                      context.read<AppBloc>().add(toDetector);
                    },
                    child: const Text(
                      'Real Time Detection',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'By: Samuel Mauricio Laime 💙',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

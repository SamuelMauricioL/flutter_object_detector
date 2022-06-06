import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detector/logic/detector.dart';

// void main() {
//   bootstrap(() => const App());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const DetectorPage(),
    );
  }
}

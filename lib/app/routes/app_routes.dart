import 'package:flutter/material.dart';
import 'package:object_detector/app/bloc/app_bloc.dart';
import 'package:object_detector/detector/detector.dart';
import 'package:object_detector/home/home.dart';

List<Page> onGenerateAppViewPages(AppState state, List<Page> pages) {
  switch (state.pageStatus) {
    case AppPageStatus.home:
      return [
        HomePage.page(),
      ];
    case AppPageStatus.detector:
      return [
        DetectorPage.page(),
      ];
  }
}

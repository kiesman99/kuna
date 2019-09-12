import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider with ChangeNotifier {

  Box get box => Hive.box("settings");

  double get course => box.get("course", defaultValue: 0.0);
  set course(double course) => box.put("course", course);

  int get primaryColor => box.get("primaryColor", defaultValue: Colors.blue.value);
  set primaryColor(int color) => box.put("primaryColor", color);

  bool get courseSet => box.get("courseSet", defaultValue: false);
  set courseSet(bool set) => box.put("courseSet", set);

  bool get tutorialWatched => box.get("tutorialWatched", defaultValue: false);
  set tutorialWatched(bool watched) => box.put("tutorialWatched", watched);

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SettingProvider with ChangeNotifier {
  String selectedGender = 'Male';
  bool swithProgress = false;
  ThemeData themeData = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
    color: Color(kMainColorApp),
  ));

  void changeSwitch(bool b) {
    swithProgress = b;
    notifyListeners();
  }

  void changeTheme(int themeNum) {
    if (themeNum == 0)
      themeData = ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
        color: Color(kMainColorApp),
      ));
    else {
      themeData = ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
        color: Color(kMainColorApp),
      ));
    }
    notifyListeners();
  }

  void getGender(String selectedValue) {
    selectedGender = selectedValue;
    notifyListeners();
  }
}

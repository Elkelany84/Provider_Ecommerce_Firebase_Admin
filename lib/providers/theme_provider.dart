import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String isDarkMode = "isDarkMode";
  bool _darkTheme = false;
  bool get getIsDarkTheme => _darkTheme;
  ThemeProvider() {
    getTheme();
  }
  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", value);
    _darkTheme = value;
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool("isDarkMode")!;
    notifyListeners();
    return _darkTheme;
  }
}

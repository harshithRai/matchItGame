import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeAreaWidth;
  static double safeAreaHeight;
  static double safeAreaHeightExcludingAppBar;
  static double safeAreaHeightExcludingBottomNavBar;
  static double safeAreaHeightExcludingAppBarAndBottomNavBar;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeAreaWidth = (screenWidth - _safeAreaHorizontal);
    safeAreaHeight = (screenHeight - _safeAreaVertical);
    safeAreaHeightExcludingAppBar = (safeAreaHeight - kToolbarHeight);
    safeAreaHeightExcludingBottomNavBar =
        (safeAreaHeight - kBottomNavigationBarHeight);
    safeAreaHeightExcludingAppBarAndBottomNavBar =
        (safeAreaHeightExcludingAppBar - kBottomNavigationBarHeight);
  }
}

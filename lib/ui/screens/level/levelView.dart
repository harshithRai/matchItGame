import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'levelMobileView.dart';

class LevelView extends StatelessWidget {
  const LevelView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: LevelMobilePortraitView(),
        landscape: LevelMobilePortraitView(),
      ),
    );
  }
}

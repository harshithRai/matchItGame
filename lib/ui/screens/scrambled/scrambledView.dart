import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'scrambledMobileView.dart';

class ScrambledView extends StatelessWidget {
  const ScrambledView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: ScrambledMobilePortraitView(),
        landscape: ScrambledMobilePortraitView(),
      ),
    );
  }
}

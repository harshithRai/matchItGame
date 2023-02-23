import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'missingMobileView.dart';

class MissingView extends StatelessWidget {
  const MissingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: MissingMobilePortraitView(),
        landscape: MissingMobileLandscapeView(),
      ),
    );
  }
}

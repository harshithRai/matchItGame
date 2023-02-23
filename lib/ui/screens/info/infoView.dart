import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'infoMobileView.dart';

class InfoView extends StatelessWidget {
  const InfoView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: InfoMobilePortraitView(),
        landscape: InfoMobileLandscapeView(),
      ),
    );
  }
}

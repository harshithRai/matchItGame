import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'matchMobileView.dart';

class MatchView extends StatelessWidget {
  const MatchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: MatchMobilePortraitView(),
        landscape: MatchMobilePortraitView(),
      ),
    );
  }
}

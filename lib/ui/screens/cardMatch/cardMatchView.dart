import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'cardMatchMobileView.dart';

class CardMatchView extends StatelessWidget {
  const CardMatchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: CardMatchMobilePortraitView(),
        landscape: CardMatchMobilePortraitView(),
      ),
    );
  }
}

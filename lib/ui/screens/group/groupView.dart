import 'package:flutter/material.dart';

import '../../responsive/orientationLayout.dart';
import '../../responsive/screenTypeLayout.dart';
import 'groupMobileView.dart';

class GroupView extends StatelessWidget {
  const GroupView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: GroupMobilePortraitView(),
        landscape: GroupMobilePortraitView(),
      ),
    );
  }
}

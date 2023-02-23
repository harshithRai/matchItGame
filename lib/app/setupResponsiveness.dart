import 'dart:ui';

import '../ui/responsive/sizeConfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void setupResponsiveSizing(context) {
  // ScreenUtil config for iPhone 11 as default
  ScreenUtil.init(
    context,
    designSize: Size(828.0, 1792.0),
    allowFontScaling: true,
  );
  SizeConfig().init(context);
}

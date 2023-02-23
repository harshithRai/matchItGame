import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';

String get adMobAppId {
  if (!kReleaseMode) {
    return FirebaseAdMob.testAppId;
  }
  if (Platform.isAndroid) {
    return "ca-app-pub-7863871388471114~7674099056";
  } else if (Platform.isIOS) {
    return "ca-app-pub-7863871388471114~2901118672";
  } else {
    throw new UnsupportedError("Unsupported platform");
  }
}

String get bannerAdUnitId {
  if (!kReleaseMode) {
    return BannerAd.testAdUnitId;
  }
  if (Platform.isAndroid) {
    return "ca-app-pub-7863871388471114/4597343728";
  } else if (Platform.isIOS) {
    return "ca-app-pub-7863871388471114/6648791997";
  } else {
    throw new UnsupportedError("Unsupported platform");
  }
}

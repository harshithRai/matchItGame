// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' as deviceSpecific;
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sentry/sentry.dart';

import 'ads/adMobConfig.dart';
import 'app/locator.dart';
import 'app/offlineStorage.dart';
import 'app/setupDialogUI.dart';
import 'ui/smartWidgets/main/startupView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAdMob.instance.initialize(appId: adMobAppId);

  await Firebase.initializeApp();
  setupLocator();
  setupDialogUI();
  await Hive.initFlutter();
  await Hive.openBox(BoxConstants.hiveBox);
  setupHiveDefaults();

  await deviceSpecific.SystemChrome.setPreferredOrientations([
    deviceSpecific.DeviceOrientation.portraitUp,
  ]);

  var sentry = SentryClient(
      dsn:
          "https://a375d14d5d2940308cb36d903faf6dd9@o395634.ingest.sentry.io/5465906");

  runZoned(
    () => runApp(StartupView()),
    onError: (Object error, StackTrace stackTrace) {
      try {
        // if (!kReleaseMode) return;
        sentry.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
        print('Error sent to sentry.io: $error');
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
        print('Original error: $error');
      }
    },
  );
}

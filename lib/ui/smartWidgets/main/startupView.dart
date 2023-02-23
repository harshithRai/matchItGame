import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/locator.dart';
import '../../../app/offlineStorage.dart';
import '../../../app/router.gr.dart' as customRoute;
import '../../../services/analyticsService.dart';
import '../../../styles/appTheme.dart';
import '../bottomNavRouter/bottomNavRouterView.dart';
import 'startupViewModel.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return ValueListenableBuilder(
      valueListenable: Hive.box(BoxConstants.hiveBox).listenable(),
      builder: (context, box, widget) {
        var themeMode = box.get(BoxConstants.themeMode);
        if (themeMode == null) {
          themeMode = "dark";
        }
        return ViewModelBuilder<StartupViewModel>.reactive(
          builder: (context, model, child) {
            return MaterialApp(
              home: (model.isBusy || !model.connectionStatus)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : BottomNavRouterView(),
              navigatorObservers: [
                locator<AnalyticsService>().getAnalyticsObserver()
              ],
              onGenerateRoute: customRoute.Router().onGenerateRoute,
              navigatorKey: locator<NavigationService>().navigatorKey,
              title: model.connectionStatus ? 'Match Me' : 'NNN',
              theme: AppTheme.customLightTheme,
              darkTheme: AppTheme.customDarkTheme,
              themeMode: themeMode == "dark" ? ThemeMode.dark : ThemeMode.light,
              // locale: DevicePreview.of(context).locale,
              // builder: DevicePreview.appBuilder,
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
            );
          },
          viewModelBuilder: () => StartupViewModel(),
          onModelReady: (model) => model.initialize(),
        );
      },
    );
  }
}

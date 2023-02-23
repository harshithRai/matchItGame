import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../smartWidgets/appBar/appBarView.dart';
import 'homeViewModel.dart';
import 'package:upgrader/upgrader.dart';

class HomeMobilePortraitView extends StatelessWidget {
  const HomeMobilePortraitView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appcastURL = 'https://incresco.github.io/matchmeappcast/appcast.xml';
    final cfg =
        AppcastConfiguration(url: appcastURL, supportedOS: ['android', 'ios']);
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return UpgradeAlert(
          appcastConfig: cfg,
          daysToAlertAgain: 1,
          debugAlwaysUpgrade: false,
          showIgnore: false,
          showLater: false,
          debugLogging: true,
          child: Scaffold(
            appBar: AppBarView(
              title: model.title,
            ),
            body: (model.isBusy)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () => model.navigateToGroups(),
                              child: Container(
                                child: Lottie.asset(
                                  (model.themeMode == "dark")
                                      ? 'assets/lottie/playButtonDark.json'
                                      : 'assets/lottie/playButton.json',
                                  width: 800.sp,
                                  height: 600.sp,
                                  repeat: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
    );
  }
}

class HomeMobileLandscapeView extends StatelessWidget {
  HomeMobileLandscapeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          'Mobile Landscape view!!!!!',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

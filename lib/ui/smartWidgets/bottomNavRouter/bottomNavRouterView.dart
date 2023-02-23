import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../screens/home/homeView.dart';
import '../../screens/info/infoView.dart';
import '../../screens/settings/settingsView.dart';
import 'bottomNavRouterViewModel.dart';
import '../../../app/setupResponsiveness.dart';

class BottomNavRouterView extends StatelessWidget {
  const BottomNavRouterView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setupResponsiveSizing(context);
    return ViewModelBuilder<BottomNavRouterViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: getViewForIndex(model.currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: model.currentIndex,
          onTap: model.setIndex,
          selectedLabelStyle: Theme.of(context)
              .bottomNavigationBarTheme
              .selectedLabelStyle
              .copyWith(
                fontSize: 24.0.sp,
              ),
          selectedIconTheme: Theme.of(context)
              .bottomNavigationBarTheme
              .selectedIconTheme
              .copyWith(
                size: 52.0.sp,
              ),
          unselectedIconTheme: Theme.of(context)
              .bottomNavigationBarTheme
              .unselectedIconTheme
              .copyWith(
                size: 52.0.sp,
              ),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                child: Icon(
                  Icons.settings,
                ),
              ),
              label: 'Settings',
              icon: Icon(
                Icons.settings,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Info',
              icon: Icon(
                Icons.info,
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => BottomNavRouterViewModel(),
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return SettingsView();
      case 2:
        return InfoView();
      default:
        return HomeView();
    }
  }
}

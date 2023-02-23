import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

import 'appBarMatchGameViewModel.dart';

class AppBarMatchGameView extends StatelessWidget
    implements PreferredSizeWidget {
  final double _preferredHeight = new AppBar().preferredSize.height;

  final String title;
  final String time;
  final Function reset;
  // final int achievementCount;

  AppBarMatchGameView({
    this.title,
    this.time,
    this.reset,
    // this.achievementCount,
  });

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBarMatchGameViewModel>.reactive(
      builder: (context, model, child) => AppBar(
        titleSpacing: 0.0,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Text(
                  "LEVEL",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 40.0.sp,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 40.0.sp,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                model.showAchievements();
                return null;
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    height: 90.0.sp,
                    width: 90.0.sp,
                    child: Icon(MdiIcons.star, size: 60.0.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(8.0.sp),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        // borderRadius: BorderRadius.circular(10.0.sp),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 45.0.sp,
                        minHeight: 45.0.sp,
                      ),
                      child: Text(
                        model.achievementCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                reset();
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 90.0.sp,
                    width: 90.0.sp,
                    child: Icon(MdiIcons.restart, size: 60.0.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  // Positioned(
                  //   right: 0,
                  //   child: Container(
                  //     padding: EdgeInsets.all(1.0.sp),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       shape: BoxShape.circle,
                  //       border: Border.all(color: Colors.white),
                  //     ),
                  //     constraints: BoxConstraints(
                  //       minWidth: 32.0.sp,
                  //       minHeight: 32.0.sp,
                  //     ),
                  //     child: Text(
                  //       '11',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 20.0.sp,
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            // resetWidget,
            Column(
              children: [
                Text(
                  "TIME",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 40.0.sp,
                  ),
                ),
                Container(
                  width: 125.0.sp,
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize: 40.0.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                model.toggleTheme();
              },
              child: (model.themeMode == "dark")
                  ? Icon(
                      Icons.wb_sunny_rounded,
                      size: 52.sp,
                    )
                  : Icon(
                      Icons.nightlight_round,
                      size: 52.sp,
                      color: Colors.white,
                    ),
            ),
          ],
        ),
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(right: ScreenUtil.pixelRatio * 6),
        //     child: GestureDetector(
        //       onTap: () {
        //         model.toggleTheme();
        //       },
        //       child: (model.themeMode == "dark")
        //           ? Icon(
        //               Icons.brightness_7,
        //             )
        //           : Icon(
        //               Icons.brightness_4,
        //             ),
        //     ),
        //   )
        // ],
      ),
      viewModelBuilder: () => AppBarMatchGameViewModel(),
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(),
    );
  }
}

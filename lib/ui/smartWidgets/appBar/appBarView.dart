import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

import './appBarViewModel.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = new AppBar().preferredSize.height;

  final String title;

  AppBarView({
    this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBarViewModel>.reactive(
      builder: (context, model, child) => AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(context).appBarTheme.textTheme.headline1.copyWith(
                    fontSize: 52.0.sp,
                  ),
            ),
            GestureDetector(
              onTap: () {
                model.showLeaderboard();
                return null;
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    height: 90.0.sp,
                    width: 90.0.sp,
                    child: Icon(MdiIcons.cup, size: 60.0.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
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
                        "1",
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
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().pixelRatio * 6),
            child: GestureDetector(
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
                    ),
            ),
          )
        ],
      ),
      viewModelBuilder: () => AppBarViewModel(),
      disposeViewModel: true,
    );
  }
}

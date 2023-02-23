import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../models/store.dart';
import '../../smartWidgets/appBar/appBarView.dart';
import 'levelViewModel.dart';

class LevelMobilePortraitView extends StatelessWidget {
  const LevelMobilePortraitView({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LevelViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBarView(
            title: model.title,
          ),
          body: SafeArea(
            child: (model.isBusy || model.levels == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: model.levelGroups.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (model.levelGroups.length > 1)
                              Container(
                                height: 210.0.sp,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.sp),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: 150.0.sp,
                                      child: SizedBox.expand(
                                        child: FittedBox(
                                          child:
                                              model.levelTypeImages != null &&
                                                      model.levelTypeImages
                                                              .length >=
                                                          index
                                                  ? SvgPicture.file(
                                                      model.levelTypeImages[
                                                          model.levelGroups.keys
                                                              .toList()[index]],
                                                    )
                                                  : CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60.0.sp,
                                      child: Text(
                                        '${model.levelGroups.keys.toList()[index]}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Column(
                              children: _buildRowList(
                                model,
                                context,
                                model.levelGroups[
                                    model.levelGroups.keys.toList()[index]],
                                model.levelGroups.keys.toList()[index],
                              ),
                            ),
                            Divider(
                              thickness: 1.0.sp,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        );
      },
      viewModelBuilder: () => LevelViewModel(),
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(),
    );
  }
}

List<Widget> _buildRowList(LevelViewModel model, BuildContext context,
    List<Level> levelList, String levelGroupName) {
  List<Widget> lines = []; // this will hold Rows according to available lines
  for (int i = 0; i < levelList.length; i = i + 4) {
    List<Widget> cols = [];
    for (int j = i; j < levelList.length && j <= i + 3; j++) {
      bool unlocked =
          model.getLevelLockStatus(levelList[j].levelId, levelGroupName);
      cols.add(
        AbsorbPointer(
          absorbing: (!unlocked),
          child: InkWell(
            onTap: () {
              model.navigateToMatchCards(
                  levelList[j].levelId, levelList[j].levelName);
            },
            child: Container(
              width: (1 / 4).sw - 34.0.sp,
              height: (1 / 4).sw - 34.0.sp,
              margin: EdgeInsets.only(
                left: 17.sp,
                right: 17.sp,
                top: 17.sp,
                bottom: 17.sp,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(
                    20.0.sp,
                  ),
                  color:
                      unlocked ? Theme.of(context).accentColor : Colors.grey),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (unlocked) ...[
                    Positioned(
                      bottom: 68.sp,
                      child: Text(
                        levelList[j].levelName.toString(),
                        style: TextStyle(
                            fontSize: 48.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 24.sp,
                      // top: 112.sp,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) {
                            var starCount =
                                model.getStarCount(levelList[j].levelId);
                            return Icon(
                              starCount <= index
                                  ? Icons.star_outline
                                  : Icons.star,
                              color: Theme.of(context).colorScheme.surface,
                            );
                          },
                        ),
                      ),
                      // color: Theme.of(context).accentColor,
                      // size: 50.sp,
                    ),
                  ],
                  if (!unlocked) ...[
                    Positioned.fill(
                      child: Icon(
                        Icons.lock_rounded,
                        size: 72.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
    lines.add(
      Row(
        children: cols,
      ),
    );
  }
  return lines;
}

Widget buildImageWidget(String imageName, File path) {
  var arr = imageName.split(".");
  switch (arr[arr.length - 1]) {
    case "svg":
      return SvgPicture.file(path);
    default:
      return Image.file(path);
  }
}

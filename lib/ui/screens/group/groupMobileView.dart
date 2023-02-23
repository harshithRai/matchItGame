import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../models/store.dart';
import '../../smartWidgets/appBar/appBarView.dart';
import 'groupViewModel.dart';

class GroupMobilePortraitView extends StatelessWidget {
  final ScrollController controller;
  GroupMobilePortraitView({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GroupViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBarView(
            title: model.title,
          ),
          body: SafeArea(
            child: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.only(
                      bottom: 120.0.sp,
                    ),
                    child: ListView.builder(
                      controller: controller,
                      itemCount: model.grouped.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: _buildRowList(
                            model,
                            context,
                            model.grouped[model.grouped.keys.toList()[index]],
                            index,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        );
      },
      viewModelBuilder: () => GroupViewModel(),
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(),
    );
  }
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

List<Widget> _buildRowList(GroupViewModel model, BuildContext context,
    List<Group> groupList, int index) {
  List<Widget> lines = []; // this will hold Rows according to available lines
  for (int i = 0; i < groupList.length; i = i + 1) {
    List<Widget> cols = [];
    for (int j = i; j < groupList.length && j <= i + 0; j++) {
      cols.add(
        InkWell(
          // splashColor: Theme.of(context).accentColor,
          onTapDown: (TapDownDetails details) {
            model.playVoice(groupList[j].voiceText);
          },
          onTap: () {
            model.navigateToLevels(
              groupList[j].groupId,
              groupList[j].groupName,
            );
          },
          child: Container(
            width: 1.sw,
            height: 300.sp,
            child: Padding(
              padding: EdgeInsets.only(
                top: 18.0.sp,
                left: 34.sp,
                right: 34.sp,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(int.parse("0xff${groupList[j].bgColor}")),
                  borderRadius: BorderRadius.circular(45.0.sp),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                          16.0.sp,
                        ),
                        child: SizedBox.expand(
                          child: FittedBox(
                            child: buildImageWidget(
                              groupList[j].imagePath,
                              groupList[j].cachedImagePath,
                            ),
                          ),
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          groupList[j].groupName.toUpperCase(),
                          textAlign: TextAlign.center,
                          //style: Theme.of(context).textTheme.headline5,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48.0.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flex: 4,
                    ),
                  ],
                ),
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

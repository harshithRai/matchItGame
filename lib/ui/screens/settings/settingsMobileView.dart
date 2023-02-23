import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../smartWidgets/appBar/appBarView.dart';
import 'settingsViewModel.dart';

class SettingsMobilePortraitView extends StatelessWidget {
  const SettingsMobilePortraitView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var optionItemIconSize = 82.sp;
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBarView(
            title: 'Settings',
          ),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            OptionItemWidget(
                              titleText: 'SOUND',
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().pixelRatio * 4.0),
                                child: Icon(
                                  model.soundOn
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: model.soundOn
                                      ? Theme.of(context).accentColor
                                      : Colors.redAccent,
                                  size: optionItemIconSize,
                                ),
                              ),
                              onTap: model.toggleSound,
                            ),
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     OptionItemWidget(
                        //       titleText: 'VOICE',
                        //     ),
                        //     ToggleButtons(
                        //       children: [
                        //         Padding(
                        //           padding: EdgeInsets.all(
                        //               ScreenUtil.pixelRatio * 4.0),
                        //           child: Icon(
                        //             MdiIcons.faceProfile,
                        //             size: optionItemIconSize,
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: EdgeInsets.all(
                        //               ScreenUtil.pixelRatio * 4.0),
                        //           child: Icon(
                        //             MdiIcons.faceWomanOutline,
                        //             size: optionItemIconSize,
                        //           ),
                        //         )
                        //       ],
                        //       isSelected: model.voiceSelections,
                        //       onPressed: (index) {
                        //         model.changeVoice(index);
                        //       },
                        //       selectedColor: Theme.of(context).accentColor,
                        //       renderBorder: false,
                        //     ),
                        //   ],
                        // ),
                        Column(
                          children: [
                            OptionItemWidget(
                              titleText: 'THEME',
                            ),
                            ToggleButtons(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      ScreenUtil().pixelRatio * 4.0),
                                  child: Icon(Icons.brightness_4,
                                      size: optionItemIconSize),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      ScreenUtil().pixelRatio * 4.0),
                                  child: Icon(Icons.brightness_7,
                                      size: optionItemIconSize),
                                ),
                              ],
                              isSelected: model.themeSelections,
                              onPressed: (index) {
                                model.changeTheme(index);
                              },
                              selectedColor: Theme.of(context).accentColor,
                              renderBorder: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
      viewModelBuilder: () => SettingsViewModel(),
      onModelReady: (model) => model.initialize(),
    );
  }
}

class OptionItemWidget extends StatelessWidget {
  final titleText;
  const OptionItemWidget({
    Key key,
    this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        color: Theme.of(context).primaryTextTheme.headline4.color,
        fontSize: ScreenUtil().setSp(82),
      ),
    );
  }
}

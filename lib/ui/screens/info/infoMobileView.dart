import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';
import '../../smartWidgets/appBar/appBarView.dart';
import 'infoViewModel.dart';

class InfoMobilePortraitView extends StatelessWidget {
  const InfoMobilePortraitView({Key key}) : super(key: key);

  Card buildCard(Color cardColor, IconData iconData, String iconLabel) {
    return Card(
      color: cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 92.sp,
          ),
          Text(
            iconLabel,
            style: TextStyle(
              fontSize: 32.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBarView(
            title: model.title,
          ),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 700.sp,
                          height: 700.sp,
                          child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 50.sp,
                              mainAxisSpacing: 50.sp,
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    Share.share(
                                        'Hey, have you tried MatchMe puzzle, its fun and informative. You can download from playstore https://play.google.com/store/apps/details?id=com.incresco.matchit'),
                                  },
                                  child: buildCard(
                                    Colors.lightBlueAccent,
                                    MdiIcons.share,
                                    'Share',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {model.reviewApp()},
                                  child: buildCard(
                                    Colors.lightBlueAccent,
                                    Icons.rate_review,
                                    'Review',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.launchUrl("email");
                                  },
                                  child: buildCard(
                                    Colors.pinkAccent,
                                    MdiIcons.emailOpen,
                                    'Email us',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {model.launchUrl("company")},
                                  child: buildCard(
                                    Colors.purpleAccent,
                                    MdiIcons.information,
                                    'About us',
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 300.sp,
                            child: FlatButton(
                              onPressed: () {
                                model.launchUrl("privacypolicy");
                              },
                              child: Text('Privacy Policy'),
                              color: Theme.of(context).buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0.sp),
                                side: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300.sp,
                            child: FlatButton(
                              onPressed: () {
                                model.launchUrl("termsofuse");
                              },
                              child: Text('Terms of Use'),
                              color: Theme.of(context).buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  18.0.sp,
                                ),
                                side: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Version ${model.packageInfo.version}',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        );
      },
      viewModelBuilder: () => locator<InfoViewModel>(),
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(),
    );
  }
}

class InfoMobileLandscapeView extends StatelessWidget {
  InfoMobileLandscapeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          'Mobile Landscape view',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

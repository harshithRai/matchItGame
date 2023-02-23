import 'package:injectable/injectable.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/locator.dart';
import '../../../services/authenticationService.dart';

@singleton
class InfoViewModel extends BaseViewModel {
  String _title = "Info";
  String get title => _title;
  String _appName = "";
  String get appName => _appName;
  String _userId;
  String get userId => _userId;
  // var box = Hive.box(BoxConstants.hiveBox);
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  PackageInfo get packageInfo => _packageInfo;

  void initialize() async {
    setBusy(true);

    final PackageInfo info = await PackageInfo.fromPlatform();
    _userId = _authenticationService.userId;
    _packageInfo = info;
    setBusy(false);
  }

  void reviewApp() async {
    LaunchReview.launch(
      androidAppId: "com.incresco.matchit",
      iOSAppId: "585027354",
    );
  }

  void launchUrl(String type) async {
    var url = "https://www.increscotech.com";
    if (type == "privacypolicy") {
      url = "https://matchme.increscotech.com/privacypolicy.html";
    } else if (type == "termsofuse") {
      url = "https://matchme.increscotech.com/terms.html";
    } else if (type == "email") {
      if (_userId != null) {
        url =
            "mailto:games@increscotech.com?subject=Greetings%20from%20${_authenticationService.userId}&body=Query%20on%MatchMe";
      } else {
        url =
            "mailto:games@increscotech.com?subject=Greetings&body=Query%20on%MatchMe";
      }
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // void appCrash() {
  //   Crashlytics.instance.log('baz');
  //   // Crashlytics.instance.crash();
  // }
}

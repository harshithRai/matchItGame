// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';

import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';
import '../../../services/connectivityService.dart';
// import '../../../services/analyticsService.dart';
// import '../../../services/authenticationService.dart';
import '../../../services/pushNotificationService.dart';
// import 'package:connectivity/connectivity.dart';

class StartupViewModel extends ReactiveViewModel {
  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();
  // final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  final ConnectivityService _connectivityService =
      locator<ConnectivityService>();
  // // String get userId => _authenticationService.userId;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_connectivityService];
  bool get connectionStatus => _connectivityService.connectionStatus;
  void initialize() async {
    setBusy(true);
    _pushNotificationService.initialise();

    // await downloadAppData();

    setBusy(false);
  }
}

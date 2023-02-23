import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/locator.dart';
import '../../../app/offlineStorage.dart';
import '../../../app/router.gr.dart';
import '../../../services/authenticationService.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  // // String get userId => _authenticationService.userId;
  // @override
  // List<ReactiveServiceMixin> get reactiveServices => [_connectivityService];
  // bool get connectionStatus => _connectivityService.connectionStatus;
  String _title = "Match Me";
  String get title => _title;
  String get userName => _authenticationService.userName;

  bool get isAnonymous => _authenticationService.isAnonymous;
  bool get isLoggedIn => _authenticationService.isLoggedIn;

  var box = Hive.box(BoxConstants.hiveBox);

  get themeMode => box.get(BoxConstants.themeMode);

  String get userId => _authenticationService.userId;

  Future navigateToGroups() async {
    setBusy(true);
    // Authenticate anonymously if no user id
    if (userId == null) {
      await _authenticationService.signInAnonymously();
    }
    // await _authenticationService.signInAnonymously();
    // await downloadUserProgressData(userId);
    await _navigationService.navigateTo(Routes.groupViewRoute);
    setBusy(false);
  }

  void initialize() async {
    setBusy(true);
    await _authenticationService.getUserLoginStatus();
    setBusy(false);
  }

  // Future signInWithGoogle() async {
  //   await _authenticationService.signInWithGoogle();
  // }
}

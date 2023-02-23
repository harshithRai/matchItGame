import 'package:hive/hive.dart';
import 'package:matchme/app/locator.dart';
import 'package:matchme/constants/enums.dart';
import 'package:matchme/services/storeService.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/offlineStorage.dart';

class AppBarViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final StoreService _storeService = locator<StoreService>();

  var box = Hive.box(BoxConstants.hiveBox);

  get themeMode => box.get(BoxConstants.themeMode);

  int _currentStarsCount = 0;
  get currentStarsCount => _currentStarsCount;

  void toggleTheme() {
    box.put(BoxConstants.themeMode,
        box.get(BoxConstants.themeMode) == "dark" ? "light" : "dark");
    notifyListeners();
  }

  void initialize() {
    // _storeService.leaderboardList.forEach((Map<String, dynamic> element) {
    //   _currentStarsCount = _currentStarsCount + element['value'];
    // });
  }

  Future<void> showLeaderboard() async {
    await _dialogService.showCustomDialog(
      variant: CustomDialogType.leaderboard,
      title: 'Leaderboard',
      description: '',
      mainButtonTitle: 'Advance to Next Level',
      showIconInMainButton: true,
      secondaryButtonTitle: 'cancel',
      showIconInSecondaryButton: true,
      customData: {'leaderboardList': _storeService.leaderboardList},
      barrierDismissible: true,
    );
  }
}

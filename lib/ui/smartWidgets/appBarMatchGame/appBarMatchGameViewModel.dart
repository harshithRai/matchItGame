import 'package:hive/hive.dart';
import 'package:matchme/app/locator.dart';
import 'package:matchme/constants/enums.dart';
import 'package:stacked/stacked.dart';

import '../../../app/offlineStorage.dart';

import '../../../services/storeService.dart';
import '../../../app/locator.dart';
import 'package:stacked_services/stacked_services.dart';

class AppBarMatchGameViewModel extends BaseViewModel {
  final StoreService _storeService = locator<StoreService>();
  final DialogService _dialogService = locator<DialogService>();

  var box = Hive.box(BoxConstants.hiveBox);

  get themeMode => box.get(BoxConstants.themeMode);
  int _achievementCount = 0;
  get achievementCount => _achievementCount;

  void toggleTheme() {
    box.put(BoxConstants.themeMode,
        box.get(BoxConstants.themeMode) == "dark" ? "light" : "dark");
    notifyListeners();
  }

  void initialize() {
    _storeService.achievements.forEach((Map<String, dynamic> element) {
      _achievementCount = _achievementCount + element['value'];
    });
  }

  Future<void> showAchievements() async {
    await _dialogService.showCustomDialog(
      variant: CustomDialogType.achievement,
      title: 'Achievements',
      description: '',
      mainButtonTitle: 'Advance to Next Level',
      showIconInMainButton: true,
      secondaryButtonTitle: 'cancel',
      showIconInSecondaryButton: true,
      customData: {'achievements': _storeService.achievements},
      barrierDismissible: true,
    );
  }
}

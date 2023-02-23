import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';

import '../../../app/offlineStorage.dart';

class SettingsViewModel extends BaseViewModel {
  var box = Hive.box(BoxConstants.hiveBox);

  List<bool> _themeSelections = [];
  List<bool> _voiceSelections = [];

  List<String> get availableThemes => ["dark", "light"];
  List<String> get availableVoices => [
        "male",
        "female",
      ];

  bool get soundOn => box.get(BoxConstants.soundOn);

  get themeSelections {
    for (var i = 0; i < availableThemes.length; i++) {
      _themeSelections[i] =
          availableThemes[i] == box.get(BoxConstants.themeMode);
    }

    return _themeSelections;
  }

  get voiceSelections => _voiceSelections;

  void changeTheme(selectedIndex) async {
    // await Hive.openBox(BoxConstants.hiveBox);
    for (int index = 0; index < _themeSelections.length; index++) {
      if (index == selectedIndex) {
        _themeSelections[index] = true;
        box.put(BoxConstants.themeMode, availableThemes[index]);
      } else {
        _themeSelections[index] = false;
      }
    }
    notifyListeners();
  }

  void changeVoice(selectedIndex) async{
    // await Hive.openBox(BoxConstants.hiveBox);
    for (int index = 0; index < _voiceSelections.length; index++) {
      if (index == selectedIndex) {
        _voiceSelections[index] = true;
        box.put(BoxConstants.voiceName, availableVoices[index]);
      } else {
        _voiceSelections[index] = false;
      }
    }
    notifyListeners();
  }

  void toggleSound() async{
    // await Hive.openBox(BoxConstants.hiveBox);
    box.put(BoxConstants.soundOn, !box.get(BoxConstants.soundOn));
    notifyListeners();
  }

  void initialize() async {
    // await Hive.openBox(BoxConstants.hiveBox);
    for (var item in availableThemes) {
      _themeSelections.add(item == box.get(BoxConstants.themeMode));
    }
    for (var item in availableVoices) {
      _voiceSelections.add(item == box.get(BoxConstants.voiceName));
    }
  }
}

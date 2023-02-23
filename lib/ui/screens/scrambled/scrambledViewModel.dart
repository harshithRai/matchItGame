import 'package:stacked/stacked.dart';

class ScrambledViewModel extends BaseViewModel {
  List<String> get data => ['G', 'O', 'O', 'G', 'L', 'E'];
  List<String> _scrambled = new List<String>();
  List<String> get scrambled => _scrambled;
  List<String> _userMatched = new List<String>();
  List<String> get userMatched => _userMatched;

  void removeCharIndex(int index) {
    print(_scrambled[index]);
    _userMatched.add(_scrambled[index]);
    _scrambled[index] = '';
    // _scrambled.removeAt(index);
    notifyListeners();
  }

  void initialize() {
    setBusy(true);
    _scrambled = data..shuffle();
    setBusy(false);
  }
}

import 'package:stacked/stacked.dart';

class MissingViewModel extends BaseViewModel {
  List<String> _alphabets = [
    'A',
    'B',
    'C',
    'D',
  ];
  List<String> get alphabetList => _alphabets;
  List<String> _modifiedAlphabets = new List<String>();

  int dragIndex;
  int moveIndex;

  int oldIndex;
  int newIndex;

  void initialize() {}

  void onDragStart(int index) {
    _modifiedAlphabets = [..._alphabets];
    dragIndex = index;
    moveIndex = index;
    notifyListeners();
  }

  void onDragAccepted(int newIndex) {
    dragIndex = null;
    moveIndex = null;
    notifyListeners();
  }

  void onDragCancelled() {
    // rest to original
    _alphabets = [..._modifiedAlphabets];
    dragIndex = null;
    moveIndex = null;
    notifyListeners();
  }

  void onMove(int index) {
    if (index == moveIndex) {
      return;
    }
    final String item = _alphabets.removeAt(moveIndex);
    _alphabets.insert(index, item);
    moveIndex = index;
    notifyListeners();
  }
}

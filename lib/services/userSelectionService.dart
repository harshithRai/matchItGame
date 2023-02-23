import 'package:injectable/injectable.dart';

@lazySingleton
class UserSelectionService {
  String _selectedGroup;
  int _selectedLevelId;
  // String _selectedLevelName;
  int _totalLevelsForGroupSelected;
  String selectedLevelNameForDisplay;

  get selectedGroup => _selectedGroup;
  get selectedLevel => _selectedLevelId;

  set setSelectedGroup(String groupId) {
    _selectedGroup = groupId;
  }

  set setSelectedLevel(int levelId) {
    _selectedLevelId = levelId;
  }

  // set setSelectedLevelName(String levelName) {
  //   _selectedLevelName = levelName;
  // }

  set setTotalLevelsForGroupSelected(int count) {
    _totalLevelsForGroupSelected = count;
  }

  get totalLevelsForGroupSelected => _totalLevelsForGroupSelected;
}

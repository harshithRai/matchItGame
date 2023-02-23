import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:matchme/services/authenticationService.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/locator.dart';
import '../../../app/router.gr.dart';
import '../../../models/store.dart';
import '../../../services/storeService.dart';
import '../../../services/userSelectionService.dart';
import '../../../services/connectivityService.dart';

import "package:collection/collection.dart";

class LevelViewModel extends ReactiveViewModel {
  final StoreService _storeService = locator<StoreService>();
  final UserSelectionService _userSelectionService =
      locator<UserSelectionService>();
  final ConnectivityService _connectivityService =
      locator<ConnectivityService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_connectivityService, _storeService];

  String get title => _storeService.store.groups
      .where(
          (element) => element.groupId == _userSelectionService.selectedGroup)
      .first
      .groupName;

  Store get store => _storeService.store;

  Map<String, File> _levelTypeImages;
  Map<String, File> get levelTypeImages => _levelTypeImages;

  Map<String, List<Level>> get levelGroups {
    if (_storeService.store.groups == null) {
      return null;
    }
    Map<String, List<Level>> _levelGrouped = groupBy(
        _storeService.store.groups
            .where((element) =>
                element.groupId == _userSelectionService.selectedGroup)
            .first
            .levels,
        (Level obj) => obj.levelType);
    return _levelGrouped;
  }

  List<Level> _levels;
  List<Level> get levels => _levels;
  List<GroupLevelPlayed> _userPlayedLevels;

  List<GroupLevelPlayed> get userPlayedLevels {
    return _userPlayedLevels;
  }

  String getScore(int levelId) {
    for (var i = 0; i < userPlayedLevels.length; i++) {
      if ('${_userSelectionService.selectedGroup}_${levelId.toString()}' ==
          userPlayedLevels[i].groupLevelIdentifier) {
        return userPlayedLevels[i].bestScoreForDisplay;
      }
    }
    return "00:00";
  }

  int getStarCount(int levelId) {
    int starCount = 0;

    for (var i = 0; i < userPlayedLevels.length; i++) {
      if ('${_userSelectionService.selectedGroup}_${levelId.toString()}' ==
          userPlayedLevels[i].groupLevelIdentifier) {
        if (userPlayedLevels[i].bestScoreInSecs >=
            _levels
                .where((element) => element.levelId == levelId)
                .first
                .oneStarSecs) {
          starCount = 1;
        } else if (userPlayedLevels[i].bestScoreInSecs >=
            _levels
                .where((element) => element.levelId == levelId)
                .first
                .twoStarSecs) {
          starCount = 2;
        } else {
          starCount = 3;
        }
        return starCount;
      }
    }
    return starCount;
  }

  bool getLevelLockStatus(int levelId, String levelGroupName) {
    var unlocked = false;

    if (userPlayedLevels
        .where((element) =>
            element.groupLevelIdentifier ==
            '${_userSelectionService.selectedGroup}_${levelId.toString()}')
        .isNotEmpty) {
      unlocked = true;
    }

    List<Level> levelGroup = levelGroups[levelGroupName];
    int levelIdIndex = levelGroups[levelGroupName]
        .indexWhere((element) => element.levelId == levelId);
    int incrementor = 0;

    for (var item in levelGroup) {
      if (userPlayedLevels
          .where((element) =>
              element.groupLevelIdentifier ==
              '${_userSelectionService.selectedGroup}_${item.levelId.toString()}')
          .isNotEmpty) {
        incrementor++;
      }
    }

    if (levelIdIndex == incrementor) {
      unlocked = true;
    }

    return unlocked;
  }

  void navigateToMatchCards(
      int selectedLevelId, String selectedLevelName) async {
    _userSelectionService.setSelectedLevel = selectedLevelId;
    _userSelectionService.selectedLevelNameForDisplay = selectedLevelName;

    // _userSelectionService.setSelectedLevelName = selectedLevelName;
    // await _navigationService.navigateTo(Routes.matchViewRoute);

    var gameType = _storeService.store.groups
        .where(
            (element) => element.groupId == _userSelectionService.selectedGroup)
        .first
        .gameType;
    if (gameType == 'matchWithoutRetry') {
      await _navigationService.navigateTo(Routes.matchViewRoute);
    } else if (gameType == 'matchWithRetry') {
      await _navigationService.navigateTo(Routes.cardMatchViewRoute);
    }
    notifyListeners();
  }

  void initialize() async {
    setBusy(true);

    try {
      _storeService
          .listenToUserStoreBroadcast(_authenticationService.userId)
          .listen((userStoreSnapshot) async {
        if (userStoreSnapshot.docs.isNotEmpty) {
          var userStore = UserStore.fromList(userStoreSnapshot.docs);
          _storeService.userStore = userStore;
        }

        if (_storeService.userStore.groupLevelPlayed != null &&
            _storeService.userStore.groupLevelPlayed.length > 0) {
          Map<String, List<GroupLevelPlayed>> grouped = groupBy(
              _storeService.userStore.groupLevelPlayed,
              (GroupLevelPlayed obj) => obj.badgeType);

          List<Map<String, dynamic>> badges = new List<Map<String, dynamic>>();

          grouped.forEach((String key, List<GroupLevelPlayed> values) {
            int badgeCount = 0;
            values.forEach((element) {
              badgeCount = badgeCount + element.badgeCount;
            });
            badges.add({'key': key, 'value': badgeCount});
          });
          _storeService.achievements = badges;
        }

        if (_storeService.userStore.groupLevelPlayed == null ||
            _storeService.userStore.groupLevelPlayed
                    .where((element) => element.groupLevelIdentifier
                        .startsWith('${_userSelectionService.selectedGroup}_'))
                    .length <=
                0) {
          _userPlayedLevels = new List<GroupLevelPlayed>();
        } else {
          _userPlayedLevels = _storeService.userStore.groupLevelPlayed
              .where((element) => element.groupLevelIdentifier
                  .startsWith('${_userSelectionService.selectedGroup}_'))
              .toList();
        }
        _levels = _storeService.store.groups
            .where((element) =>
                element.groupId == _userSelectionService.selectedGroup)
            .first
            .levels;
        Map<String, dynamic> _levelTypes = _storeService.store.groups
            .where((element) =>
                element.groupId == _userSelectionService.selectedGroup)
            .first
            .levelTypeImages;

        if (_levelTypes != null && _levelTypes.length > 0) {
          List<File> levelTypeCachedImage = await Future.wait(
            _levelTypes.values.map((e) {
              return DefaultCacheManager()
                  .getSingleFile('https://matchme.increscotech.com/$e');
            }),
          );

          Map<String, File> images = new Map<String, File>();

          for (var i = 0; i < levelTypeCachedImage.length; i++) {
            images[_levelTypes.keys.elementAt(i)] = levelTypeCachedImage[i];
          }

          _levelTypeImages = images;
        }
        setBusy(false);
      });
    } catch (e) {
      print(e);
    }
  }
}

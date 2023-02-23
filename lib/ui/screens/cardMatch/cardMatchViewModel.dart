import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/locator.dart';
import '../../../app/router.gr.dart';
import '../../../constants/enums.dart';
import '../../../models/store.dart';
import '../../../services/storeService.dart';
import '../../../services/userSelectionService.dart';
import '../../../services/utilitiesService.dart';
import '../../../app/offlineStorage.dart';
import 'package:hive/hive.dart';

import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CardMatchViewModel extends ReactiveViewModel {
  final UserSelectionService _userSelectionService =
      locator<UserSelectionService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  final StoreService _storeService = locator<StoreService>();
  final UtilitiesService _utilitiesService = locator<UtilitiesService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_storeService];
  var box = Hive.box(BoxConstants.hiveBox);

  get themeMode => box.get(BoxConstants.themeMode);

  int _randomSeed = 0;
  int _matchCardCount = 0;
  int _currentScore = 0;

  List<MatchCard> _cards = new List<MatchCard>();
  Store _store;
  String _title = "Match Cards";

  var stopWatch = Stopwatch();

  final duration = const Duration(seconds: 1);
  String _durationPlayed = "00:00";

  int _durationInSeconds = 0;
  String get durationPlayed => _durationPlayed;

  int get matchCardCount => _matchCardCount;

  List<MatchCard> get matchCards => _cards;

  int get randomSeed => _randomSeed;
  Store get store => _store;

  Map<String, int> _badges;
  Map<String, int> get badges => _badges;

  Level _level;

  String get currentLevel => _userSelectionService.selectedLevelNameForDisplay;

  bool _leftShowDraggable = true;
  bool _rightShowDraggable = true;

  bool get leftShowDraggable => _leftShowDraggable;
  bool get rightShowDraggable => _rightShowDraggable;

  void markDragStatus(String side) {
    if (side == "left") {
      _rightShowDraggable = false;
      _leftShowDraggable = true;
      notifyListeners();
    }
    if (side == "right") {
      _rightShowDraggable = true;
      _leftShowDraggable = false;
      notifyListeners();
    }
    if (side == "none") {
      _rightShowDraggable = true;
      _leftShowDraggable = true;
      notifyListeners();
    }
  }

  String get title => _title;
  void advanceToNextLevel() {
    var totalLevels = _store.groups
        .where(
            (element) => element.groupId == _userSelectionService.selectedGroup)
        .first
        .levels
        .length;
    if (_userSelectionService.selectedLevel < totalLevels) {
      _userSelectionService.setSelectedLevel =
          _userSelectionService.selectedLevel + 1;
      _navigationService.replaceWith(Routes.cardMatchViewRoute);
    } else {
      _navigationService
          .popUntil((route) => route.settings.name == Routes.groupViewRoute);
    }
  }

  @override
  void dispose() {
    stopStopWatch();
    super.dispose();
  }

  void incrementScore(int index) async {
    _currentScore++;

    getPosition(index);
    if (_currentScore == _matchCardCount) {
      stopWatch.stop();
      _durationInSeconds = stopWatch.elapsed.inSeconds;

      int starCount = 3;
      if (_durationInSeconds >= _level.oneStarSecs) {
        starCount = 1;
      } else if (_durationInSeconds >= _level.twoStarSecs) {
        starCount = 2;
      }

      _storeService.updateUserStore(
          _userSelectionService.selectedGroup,
          _userSelectionService.selectedLevel,
          _durationInSeconds,
          starCount,
          "star");

      var response = await _dialogService.showCustomDialog(
        variant: CustomDialogType.levelCompleted,
        title: '',
        description: '',
        mainButtonTitle: 'Advance to Next Level',
        showIconInMainButton: true,
        secondaryButtonTitle: 'cancel',
        showIconInSecondaryButton: true,
        customData: {
          'durationPlayed':
              _utilitiesService.formatTimeInMinsSecs(_durationInSeconds),
          'starCount': starCount,
        },
      );
      if (response.confirmed) {
        advanceToNextLevel();
      } else {
        if (response.responseData == "home") {
          _navigationService.popUntil(
              (route) => route.settings.name == Routes.groupViewRoute);
        } else if (response.responseData == "reset") {
          resetCards();
        }
      }
    }
  }

  // String getImageString(String imagePath) {
  //   return _storeService.getImageString(imagePath);
  // }

  Map<int, File> _sourceImageCachedPath = new Map<int, File>();
  Map<int, File> get sourceImageCachedPath => _sourceImageCachedPath;
  Map<int, File> _matchImageCachedPath = new Map<int, File>();
  Map<int, File> get matchImageCachedPath => _matchImageCachedPath;

  void initialize() async {
    setBusy(true);
    _currentScore = 0;
    _store = _storeService.store;

    _level = _store.groups
        .where(
            (element) => element.groupId == _userSelectionService.selectedGroup)
        .first
        .levels
        .where(
            (element) => element.levelId == _userSelectionService.selectedLevel)
        .first;

    _cards = _level.matchCards;
    _matchCardCount = _cards.length;

    _randomSeed = 2 + new Random().nextInt(_matchCardCount + 2);

    List<File> filesSourceList = new List<File>();

    if (matchCards[0].sourceImagePath != null &&
        matchCards[0].sourceImagePath.isNotEmpty) {
      filesSourceList = await Future.wait(
        matchCards.map((d) {
          return DefaultCacheManager().getSingleFile(
              'https://matchme.increscotech.com/${d.sourceImagePath}');
        }),
      );
    }

    List<File> filesMatchList = new List<File>();
    if (matchCards[0].matchImagePath != null &&
        matchCards[0].matchImagePath.isNotEmpty) {
      filesMatchList = await Future.wait(
        matchCards.map((d) {
          return DefaultCacheManager().getSingleFile(
              'https://matchme.increscotech.com/${d.matchImagePath}');
        }),
      );
    }

    for (int i = 0; i < matchCardCount; i++) {
      sourceKey.add(new GlobalKey());
      matchKey.add(new GlobalKey());
      matchCards[i].isMatched = false;

      if (matchCards[i].sourceImagePath != null &&
          matchCards[i].sourceImagePath.isNotEmpty) {
        _sourceImageCachedPath.addAll({matchCards[i].id: filesSourceList[i]});
      }
      if (matchCards[i].matchImagePath != null &&
          matchCards[i].matchImagePath.isNotEmpty) {
        _matchImageCachedPath.addAll({matchCards[i].id: filesMatchList[i]});
      }
    }
    // _badges = _storeService.badgesAcquired;
    print(_badges);

    notifyListeners();

    startStopWatch();
    // WidgetsBinding.instance.addPostFrameCallback((_) => getPosition(context));
    setBusy(false);
  }

  List<GlobalKey> sourceKey = new List<GlobalKey>();
  List<GlobalKey> matchKey = new List<GlobalKey>();
  List<Offset> sourceOffset = new List<Offset>();
  List<Offset> matchOffset = new List<Offset>();
  Size sourceCardSize;
  Size matchCardSize;

  void getPosition(int index) {
    RenderBox _sourceBox = sourceKey[index].currentContext.findRenderObject();
    RenderBox _matchBox = matchKey[index].currentContext.findRenderObject();

    Offset sourceCardPosition = _sourceBox.localToGlobal(Offset.zero);
    Offset matchCardPosition = _matchBox.localToGlobal(Offset.zero);
    sourceCardSize = _sourceBox.size;
    matchCardSize = _matchBox.size;
    sourceOffset.add(sourceCardPosition);
    matchOffset.add(matchCardPosition);
  }

  void keepRunning() {
    if (stopWatch.isRunning) {
      startTimer();
    }
    _durationPlayed =
        (stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");

    notifyListeners();
  }

  void resetCards() async {
    resetStopWatch();
    _randomSeed = 2 + new Random().nextInt(_matchCardCount + 2);
    _currentScore = 0;
    for (int i = 0; i < matchCardCount; i++) {
      matchCards[i].isMatched = false;
    }
    sourceOffset = new List<Offset>();
    matchOffset = new List<Offset>();
    notifyListeners();
  }

  void resetStopWatch() {
    stopStopWatch();
    stopWatch.reset();
    startStopWatch();

    notifyListeners();
  }

  void startStopWatch() {
    stopWatch.start();
    startTimer();
  }

  void startTimer() {
    Timer(duration, keepRunning);
    notifyListeners();
  }

  void stopStopWatch() {
    _durationInSeconds = stopWatch.elapsed.inSeconds;
    stopWatch.stop();
    notifyListeners();
  }

  void playVoice(String textToPlay) async {
    await _utilitiesService.playVoice(textToPlay);
  }

  Map<String, int> getRowColCount(int count) {
    int row = 1;
    int col = 1;

    switch (count) {
      case 2:
        row = 1;
        col = 2;
        break;
      case 3:
        row = 2;
        col = 2;
        break;
      case 4:
        row = 2;
        col = 2;
        break;
      case 5:
        row = 2;
        col = 3;
        break;
      case 6:
        row = 2;
        col = 3;
        break;
      case 7:
        row = 3;
        col = 3;
        break;
      case 8:
        row = 3;
        col = 3;
        break;
      case 9:
        row = 3;
        col = 3;
        break;
      case 10:
        row = 3;
        col = 4;
        break;
      case 11:
        row = 3;
        col = 4;
        break;
      case 12:
        row = 3;
        col = 4;
        break;
      case 13:
        row = 4;
        col = 4;
        break;
      case 14:
        row = 4;
        col = 4;
        break;
      case 15:
        row = 4;
        col = 4;
        break;
      case 16:
        row = 4;
        col = 4;
        break;

      case 17:
        row = 5;
        col = 4;
        break;
      case 18:
        row = 5;
        col = 4;
        break;
      case 19:
        row = 5;
        col = 4;
        break;
      case 20:
        row = 5;
        col = 4;
        break;
      case 21:
        row = 5;
        col = 5;
        break;
      case 22:
        row = 5;
        col = 5;
        break;
      case 23:
        row = 5;
        col = 5;
        break;
      case 24:
        row = 5;
        col = 5;
        break;
      case 25:
        row = 5;
        col = 5;
        break;
    }

    return {'row': row, 'col': col};
  }
}

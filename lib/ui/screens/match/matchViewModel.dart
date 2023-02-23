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

class MatchViewModel extends ReactiveViewModel {
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
  int _playedCount = 0;
  int _score = 0;
  bool _showReset = false;
  bool get showReset => _showReset;

  List<GlobalKey> sourceKey = new List<GlobalKey>();
  List<GlobalKey> matchKey = new List<GlobalKey>();
  List<Offset> sourceOffsetList = new List<Offset>();
  List<Offset> matchOffsetList = new List<Offset>();
  List<Color> lineColors = new List<Color>();
  Size sourceCardSize;
  Size matchCardSize;

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
      _navigationService.replaceWith(Routes.matchViewRoute);
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

  void getPosition(int sourceIndex, int matchIndex, bool success) {
    RenderBox _sourceBox =
        sourceKey[sourceIndex].currentContext.findRenderObject();
    RenderBox _matchBox =
        matchKey[matchIndex].currentContext.findRenderObject();

    Offset sourceCardPosition = _sourceBox.localToGlobal(Offset.zero);
    Offset matchCardPosition = _matchBox.localToGlobal(Offset.zero);
    sourceCardSize = _sourceBox.size;
    matchCardSize = _matchBox.size;
    sourceOffsetList.add(sourceCardPosition);
    matchOffsetList.add(matchCardPosition);
    if (success) {
      lineColors.add(Colors.green);
    } else {
      lineColors.add(Colors.red);
    }
  }

  void incrementScore(int score, int played, String sourceIdString, int matchId,
      bool isSourcePlayed) async {
    int _sourceId = int.parse(sourceIdString);

    int _sourceIndex = matchCards
        .indexOf(matchCards.where((element) => element.id == _sourceId).first);
    int _matchIndex = matchCards
        .indexOf(matchCards.where((element) => element.id == matchId).first);
    if (isSourcePlayed) {
      getPosition(_matchIndex, _sourceIndex, score > 0);
    } else {
      getPosition(_sourceIndex, _matchIndex, score > 0);
    }

    _playedCount++;
    _score = _score + score;

    if (score == 0) {
      _showReset = true;
    }

    if (_playedCount == _matchCardCount) {
      stopWatch.stop();
      _durationInSeconds = stopWatch.elapsed.inSeconds;

      int starCount = 3;
      if (_durationInSeconds >= _level.oneStarSecs) {
        starCount = 1;
      } else if (_durationInSeconds >= _level.twoStarSecs) {
        starCount = 2;
      }
      if (_score < _playedCount) {
        starCount = 0;
      }

      if (_matchCardCount == _score) {
        _storeService.updateUserStore(
            _userSelectionService.selectedGroup,
            _userSelectionService.selectedLevel,
            _durationInSeconds,
            starCount,
            "star");
      }

      var response = await _dialogService.showCustomDialog(
        variant: (_matchCardCount == _score)
            ? CustomDialogType.levelCompleted
            : CustomDialogType.levelFailed,
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
    notifyListeners();
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
    _playedCount = 0;
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
      matchCards[i].isSourcePlayed = false;
      matchCards[i].isDestinationPlayed = false;

      if (matchCards[i].sourceImagePath != null &&
          matchCards[i].sourceImagePath.isNotEmpty) {
        _sourceImageCachedPath.addAll({matchCards[i].id: filesSourceList[i]});
      }
      if (matchCards[i].matchImagePath != null &&
          matchCards[i].matchImagePath.isNotEmpty) {
        _matchImageCachedPath.addAll({matchCards[i].id: filesMatchList[i]});
      }
    }

    notifyListeners();

    startStopWatch();
    setBusy(false);
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
    _playedCount = 0;
    _score = 0;
    _showReset = false;
    for (int i = 0; i < matchCardCount; i++) {
      matchCards[i].isMatched = false;
      matchCards[i].isDestinationPlayed = false;
      matchCards[i].isSourcePlayed = false;
    }
    sourceOffsetList = new List<Offset>();
    matchOffsetList = new List<Offset>();
    lineColors = new List<Color>();
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

import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:matchme/services/cloudFunctionsService.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import '../app/locator.dart';
import '../models/store.dart';
import '../services/authenticationService.dart';

@lazySingleton
class StoreService with ReactiveServiceMixin {
  StoreService() {
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    listenToReactiveValues([
      _store,
      _userStore,
    ]);
  }

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final CollectionReference _storeCollectionReference =
      FirebaseFirestore.instance.collection("store");

  final CollectionReference _userStoreCollectionReference =
      FirebaseFirestore.instance.collection("userStore");

  final CloudFunctionsService _cloudFunctionsService =
      locator<CloudFunctionsService>();

  RxValue<Store> _store = RxValue<Store>(initial: new Store());

  RxValue<UserStore> _userStore = RxValue<UserStore>(initial: new UserStore());

  Store get store => _store.value;
  String get userId => _authenticationService.userId;
  UserStore get userStore => _userStore.value;
  List<Map<String, dynamic>> _achievements = [
    {'key': "star", 'value': 0},
    {'key': "gold", 'value': 0}
  ];
  List<Map<String, dynamic>> get achievements => _achievements;

  List<Map<String, dynamic>> _leaderboardList;
  // [
  //   {'username': "user1", 'score': 11},
  //   {'username': "user2", 'score': 10},
  //   {'username': "user3", 'score': 9},
  //   {'username': "user4", 'score': 8},
  //   {'username': "user5", 'score': 5}
  // ];
  List<Map<String, dynamic>> get leaderboardList => _leaderboardList;

  set achievements(List<Map<String, dynamic>> data) {
    _achievements.forEach((element) {
      var item = data.where((e) => e['key'] == element['key']);
      if (item.isNotEmpty) {
        element['value'] = item.first['value'];
      }
    });
  }
  // set badgesAcquired(Map<String, int> data) {
  //   data.forEach((key, value) {
  //     _badgesAcquired[key] = value;
  //   });
  // }

  set userStore(UserStore data) {
    _userStore.value = data;
  }

  set store(Store data) {
    _store.value = data;
  }

  // Stream listenToStoreRealTime() {
  //   _storeCollectionReference.snapshots().listen((storeSnapshot) {
  //     if (storeSnapshot.docs.isNotEmpty) {
  //       var store = Store.fromList(storeSnapshot.docs);
  //       _store.value = store;
  //       _storeController.add(_store);
  //     }
  //   });

  //   return _storeController.stream;
  // }

  // Stream listenToUserStoreRealTime(String userId) {
  //   _userStoreCollectionReference
  //       .doc(userId)
  //       .collection("groupLevel")
  //       .snapshots()
  //       .listen((userStoreSnapshot) {
  //     if (userStoreSnapshot.docs.isNotEmpty) {
  //       print('entereted in');
  //       var userStore = UserStore.fromList(userStoreSnapshot.docs);
  //       _userStore.value = userStore;
  //       _userStoreController.add(userStore);
  //     }
  //   });

  //   return _userStoreController.stream;
  // }

  Stream listenToStoreBroadcast() {
    return _storeCollectionReference.snapshots().asBroadcastStream();
  }

  Stream listenToUserStoreBroadcast(String userId) {
    Stream stream;
    try {
      stream = _userStoreCollectionReference
          .doc(userId)
          .collection("groupLevel")
          .snapshots()
          .asBroadcastStream();
    } catch (e) {
      print(e);
    }
    return stream;
  }

  Future updateUserStore(String groupId, int levelIndex, int score,
      int badgeCount, String badgeType) async {
    try {
      var groupLevelIdentifier = '${groupId}_$levelIndex';

      var currentBestScore = score;
      int currentBadgeCount = badgeCount;

      var playedLevel = _userStore.value.groupLevelPlayed?.where(
          (element) => element.groupLevelIdentifier == groupLevelIdentifier);

      if (playedLevel != null && playedLevel.isNotEmpty) {
        print('inside');
        currentBestScore = playedLevel.first.bestScoreInSecs;
        currentBadgeCount = playedLevel.first.badgeCount;
        if (score < currentBestScore) {
          currentBestScore = score;
        }
        if (currentBadgeCount < badgeCount) {
          currentBadgeCount = badgeCount;
        }
      }
      var played = GroupLevelPlayed(
        groupLevelIdentifier: groupLevelIdentifier,
        bestScoreInSecs: currentBestScore,
        lastPlayedScoreInSecs: score,
        badgeType: badgeType,
        badgeCount: currentBadgeCount,
      ).toMap();
      print(played);
      print(userId);
      await _userStoreCollectionReference
          .doc(userId)
          .collection("groupLevel")
          .doc(groupLevelIdentifier)
          .set(played, SetOptions(merge: true));
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  getLeaderboardList() async {
    try {
      await _cloudFunctionsService.getLeaderboardWithCurrentPosition(userId);
    } catch (exc) {
      return exc.toString();
    }
  }
}

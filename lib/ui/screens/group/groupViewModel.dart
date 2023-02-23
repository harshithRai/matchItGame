import 'dart:io';

import "package:collection/collection.dart";
import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../ads/adMobConfig.dart';
import '../../../app/locator.dart';
import '../../../app/router.gr.dart';
import '../../../models/store.dart';
import '../../../services/analyticsService.dart';
import '../../../services/storeService.dart';
import '../../../services/userSelectionService.dart';
import '../../../services/utilitiesService.dart';

class GroupViewModel extends ReactiveViewModel {
  final StoreService _storeService = locator<StoreService>();
  final UserSelectionService _userSelectionService =
      locator<UserSelectionService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final UtilitiesService _utilitiesService = locator<UtilitiesService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_storeService];

  // Ads

  // bool _adLoaded = false;

  BannerAd _bannerAd;

  BannerAd adBanner = BannerAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: bannerAdUnitId,
    size: AdSize.banner,
    // targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  void showAd() {
    adBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );

    // _adLoaded = true;
  }

  String _title = "Groups";

  Store _store;

  Store get store => _store;

  String get title => _title;

  List<File> _imageCachedPath = new List<File>();
  List<File> get imageCachedPath => _imageCachedPath;

  Map<String, List<Group>> _grouped;
  Map<String, List<Group>> get grouped => _grouped;

  void initialize() async {
    setBusy(true);
    _storeService.listenToStoreBroadcast().listen((storeSnapshot) async {
      if (storeSnapshot.docs.isNotEmpty) {
        var store = Store.fromList(storeSnapshot.docs);
        _storeService.store = store;
        _store = store;
        _imageCachedPath = await Future.wait(
          _storeService.store.groups.map((d) {
            return DefaultCacheManager().getSingleFile(
                'https://matchme.increscotech.com/${d.imagePath}');
          }),
        );

        for (int i = 0; i < _store.groups.length; i++) {
          _store.groups[i].cachedImagePath = _imageCachedPath[i];
        }

        _grouped =
            groupBy(_storeService.store.groups, (Group obj) => obj.groupType);
      }
      setBusy(false);
    });

    // Ad
    _bannerAd = _utilitiesService.createBannerAd()..load();
    _bannerAd..show();

    // if (!kReleaseMode) {
    //   showAd();
    // }
  }

  void navigateToLevels(String selectedGroup, String groupName) async {
    _userSelectionService.setSelectedGroup = selectedGroup;
    await _analyticsService.logGroupClicked(groupName: groupName);
    await _navigationService.navigateTo(Routes.levelViewRoute);

    // _navigationService.navigateTo(Routes.scrambledViewRoute);
  }

  void playVoice(String textToPlay) async {
    await _utilitiesService.playVoice(textToPlay);
  }

  void dispose() {
    try {
      // if (_adLoaded) {
      //   adBanner?.dispose();
      //   adBanner = null;
      //   _adLoaded = false;
      // }
      _bannerAd?.dispose();
    } catch (ex) {}
    super.dispose();
  }
}

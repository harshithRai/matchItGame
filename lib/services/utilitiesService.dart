import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:matchme/ads/adMobConfig.dart';

import '../app/offlineStorage.dart';

import 'package:firebase_admob/firebase_admob.dart';

@lazySingleton
class UtilitiesService {
  final FlutterTts _flutterTts = FlutterTts();

  String formatTimeInMinsSecs(int durationInSecs) {
    Duration duration = Duration(seconds: durationInSecs.round());
    var durationFormatted = [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');

    return durationFormatted;
  }

  Future<bool> playVoice(String textToPlay) async {
    await Hive.openBox(BoxConstants.hiveBox);
    var box = Hive.box(BoxConstants.hiveBox);
    if (!box.get(BoxConstants.soundOn)) {
      return true;
    }

    // var te = await _flutterTts.getLanguages;
    // for (var item in te) {
    //   if (item.toString().contains("ta")) {
    //     print(item);
    //   }
    // }

    await _flutterTts.setLanguage("en-US");

    // await _flutterTts.setLanguage('ta-IN');

    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(textToPlay);

    return true;
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      // targetingInfo: MobileAdTargetingInfo(
      //   childDirected: true,
      // ),
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
}

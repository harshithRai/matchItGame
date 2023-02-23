import 'package:hive/hive.dart';

class BoxConstants {
  static const String hiveBox = "hiveBox";
  static const String soundOn = "soundOn";
  static const String themeMode = "themeMode";
  static const String voiceName = "voiceName";
  static const String zipFileVersionNumber = "versionNumber";
  static const String zipFileName = "zipFileName";
  static const String appImageFilesInfo = "appImageFilesInfo";
}

// Future<bool> downloadAppData() async {
//   final StoreService _storeService = locator<StoreService>();
//   _storeService.listenToStoreRealTime().listen((event) {
//     return true;
//   });
//   return false;
// }

// Future<bool> getAppLastSyncData() async {
//   final StoreService _storeService = locator<StoreService>();
//   _storeService.listenToStoreRealTime().listen((event) {
//     return true;
//   });
//   return false;
// }

// Future<bool> downloadUserProgressData(userId) async {
//   final StoreService _storeService = locator<StoreService>();
//   _storeService.listenToUserStoreRealTime(userId).listen((event) {
//     return true;
//   });
//   return false;
// }

// Future<bool> downloadImageStoreData() async {
//   final StoreService _storeService = locator<StoreService>();
//   _storeService.listenToImageStoreRealTime().listen((event) {
//     return true;
//   });
//   return false;
// }

void setupHiveDefaults() async {
  var box = Hive.box(BoxConstants.hiveBox);

  if (box.get(BoxConstants.soundOn) == null) {
    box.put(BoxConstants.soundOn, true);
  }
  if (box.get(BoxConstants.themeMode) == null) {
    box.put(BoxConstants.themeMode, "dark");
  }
  if (box.get(BoxConstants.voiceName) == null) {
    box.put(BoxConstants.voiceName, "female");
  }

  if (box.get(BoxConstants.zipFileName) == null) {
    box.put(BoxConstants.zipFileName, null);
  }
  if (box.get(BoxConstants.zipFileVersionNumber) == null) {
    box.put(BoxConstants.zipFileVersionNumber, 0);
  }
  if (box.get(BoxConstants.appImageFilesInfo) == null) {
    await box.put(BoxConstants.appImageFilesInfo, null);
  }
}

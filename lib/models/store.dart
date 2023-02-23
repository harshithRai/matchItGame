import 'dart:io';

class Store {
  final List<Group> groups;
  Store({this.groups});

  static Store fromList(List<dynamic> snapshotList) {
    List<Group> groups = new List<Group>();
    groups = snapshotList.map((e) => Group.fromMap(e.data(), e.id)).toList();
    groups.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return new Store(groups: groups);
  }
}

class Group {
  final String groupId;
  final String groupName;
  final String imagePath;
  final String voiceText;
  final List<Level> levels;
  final Map<String, dynamic> levelTypeImages;
  final int displayOrder;
  final String groupType;
  final String gameType;
  final String bgColor;
  File cachedImagePath;

  Group({
    this.groupId,
    this.groupName,
    this.imagePath,
    this.voiceText,
    this.levels,
    this.displayOrder,
    this.cachedImagePath,
    this.gameType,
    this.groupType,
    this.levelTypeImages,
    this.bgColor,
  });

  static Group fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    List<dynamic> levelsSnapshot = map['levels'];
    List<Level> levels = new List<Level>();
    levels = levelsSnapshot.map((e) => Level.fromMap(e)).toList();

    return Group(
      groupId: documentId,
      groupName: map['name'],
      imagePath: map['image'],
      voiceText: map['name'],
      levels: levels,
      displayOrder: map['displayOrder'] != null ? map['displayOrder'] : 100,
      gameType: map['gameType'],
      levelTypeImages:
          map['levelTypeImages'] != null ? map['levelTypeImages'] : null,
      bgColor: map['bgColor'] != null ? map['bgColor'] : "45a3df",
    );
  }
}

class Level {
  final int levelId;
  final bool unlock;
  final bool onlineOnly;
  final int oneStarSecs;
  final int twoStarSecs;
  final String levelName;

  final String levelType;
  final List<MatchCard> matchCards;
  String userPlayedState;

  Level({
    this.levelId,
    this.unlock,
    this.onlineOnly,
    this.matchCards,
    this.oneStarSecs,
    this.twoStarSecs,
    this.levelType,
    this.levelName,
  });
  static Level fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    try {
      List<dynamic> cardsSnapshot = map['cards'];
      List<MatchCard> matchCards = new List<MatchCard>();
      String gameType = map['gameType'] != null ? map['gameType'] : 'match';
      matchCards = gameType == 'match'
          ? cardsSnapshot.map((e) => MatchCard.fromMap(e)).toList()
          : null;
      return Level(
        levelId: map['levelId'],
        unlock: map['unlock'] != null ? map['unlock'] : true, // change
        onlineOnly: map['onlineOnly'] != null ? map['onlineOnly'] : false,
        matchCards: matchCards,
        oneStarSecs: map['1StarSecs'] != null ? map['1StarSecs'] : 20,
        twoStarSecs: map['2StarSecs'] != null ? map['2StarSecs'] : 10,
        levelType: map['levelType'],
        levelName: map['levelName'],
      );
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}

class MatchCard {
  final int id;
  final String matchImagePath;
  final String sourceImagePath;
  final String sourceText;
  final String matchText;
  final String sourceVoice;
  final String matchVoice;
  final String finalImagePath;
  final bool clipCard;
  final String clipType;
  final int matchImageCount;
  final int sourceImageCount;
  final bool showShadow;
  final String sourceWidgetType;
  final String matchWidgetType;

  bool isMatched = false;
  bool isSourcePlayed = false;
  bool isDestinationPlayed = false;
  MatchCard({
    this.matchImagePath,
    this.sourceImagePath,
    this.id,
    this.sourceText,
    this.sourceVoice,
    this.matchText,
    this.matchVoice,
    this.finalImagePath,
    this.clipCard,
    this.clipType,
    this.matchImageCount,
    this.sourceImageCount,
    this.showShadow,
    this.sourceWidgetType,
    this.matchWidgetType,
  });
  static MatchCard fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return MatchCard(
      matchImagePath: map['dSrc'],
      sourceImagePath: map['sSrc'],
      sourceText: map['sName'],
      matchText: map['dName'],
      sourceVoice: map['sName'],
      matchVoice: map['dName'],
      id: map['id'],
      finalImagePath: map['finalSrc'] != null ? map['finalSrc'] : null,
      clipCard: map['clipType'] != null,
      clipType: map['clipType'] != null ? map['clipType'] : null,
      matchImageCount: map['dCount'] != null ? map['dCount'] : 1,
      sourceImageCount: map['sCount'] != null ? map['sCount'] : 1,
      showShadow: map['showShadow'] != null ? map['showShadow'] : false,
      sourceWidgetType:
          map['sWidgetType'] != null ? map['sWidgetType'] : "image",
      matchWidgetType:
          map['dWidgetType'] != null ? map['dWidgetType'] : "image",
    );
  }
}

// End of Store

// User related

class UserStore {
  final List<GroupLevelPlayed> groupLevelPlayed;
  UserStore({
    this.groupLevelPlayed,
  });

  static UserStore fromList(List<dynamic> snapshotList) {
    List<GroupLevelPlayed> groupLevelPlayed = new List<GroupLevelPlayed>();
    groupLevelPlayed = snapshotList
        .map((e) => GroupLevelPlayed.fromMap(e.data(), e.id))
        .toList();

    return new UserStore(groupLevelPlayed: groupLevelPlayed);
  }
}

class GroupLevelPlayed {
  final String groupLevelIdentifier;
  final int bestScoreInSecs;
  final int lastPlayedScoreInSecs;
  final int badgeCount;
  final String badgeType;
  String bestScoreForDisplay;
  String lastPlayedScoreForDisplay;
  GroupLevelPlayed({
    this.groupLevelIdentifier,
    this.bestScoreInSecs,
    this.lastPlayedScoreInSecs,
    this.bestScoreForDisplay,
    this.lastPlayedScoreForDisplay,
    this.badgeCount,
    this.badgeType,
  });

  Map<String, dynamic> toMap() {
    return {
      'best': bestScoreInSecs,
      'lastP': lastPlayedScoreInSecs,
      'badgeType': badgeType,
      'badgeCount': badgeCount,
    };
  }

  static GroupLevelPlayed fromMap(Map<String, dynamic> map, String id) {
    if (map == null) return null;
    Duration bestScoreDuration = Duration(seconds: map['best'].round());
    var bestScoreDurationFormatted = [
      bestScoreDuration.inMinutes,
      bestScoreDuration.inSeconds
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
    return GroupLevelPlayed(
      groupLevelIdentifier: id,
      bestScoreInSecs: map['best'],
      lastPlayedScoreInSecs: map['lastP'],
      badgeType: map['badgeType'] != null ? map['badgeType'] : 'star',
      badgeCount: map['badgeCount'] != null ? map['badgeCount'] : 0,
      bestScoreForDisplay: bestScoreDurationFormatted,
      lastPlayedScoreForDisplay: bestScoreDurationFormatted,
    );
  }
}

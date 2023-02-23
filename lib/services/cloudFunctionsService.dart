import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class CloudFunctionsService {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  List _leaderboard = new List();
  List get leaderboard => _leaderboard;

  Future<List> getLeaderboardWithCurrentPosition(
      @required String userId) async {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('getLeaderboardWithCurrentPosition');
    final results = await callable();
    return results.data;
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

@singleton
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties(
      {@required String userId, @required String userType}) async {
    await _analytics.setUserId(userId);
    // Set the user_role
    await _analytics.setUserProperty(name: 'user_type', value: userType);
  }

  Future logLogin(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future logSignUp(String signUpMethod) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future logGroupClicked({String groupName}) async {
    await _analytics.logEvent(
      name: 'group_click',
      parameters: {'group_name': groupName},
    );
  }
}

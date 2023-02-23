// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/screens/cardMatch/cardMatchView.dart';
import '../ui/screens/group/groupView.dart';
import '../ui/screens/home/homeView.dart';
import '../ui/screens/info/infoView.dart';
import '../ui/screens/level/levelView.dart';
import '../ui/screens/match/matchView.dart';
import '../ui/screens/missing/missingView.dart';
import '../ui/screens/scrambled/scrambledView.dart';

class Routes {
  static const String homeViewRoute = '/';
  static const String groupViewRoute = '/group-view';
  static const String levelViewRoute = '/level-view';
  static const String cardMatchViewRoute = '/card-match-view';
  static const String infoViewRoute = '/info-view';
  static const String missingViewRoute = '/missing-view';
  static const String scrambledViewRoute = '/scrambled-view';
  static const String matchViewRoute = '/match-view';
  static const all = <String>{
    homeViewRoute,
    groupViewRoute,
    levelViewRoute,
    cardMatchViewRoute,
    infoViewRoute,
    missingViewRoute,
    scrambledViewRoute,
    matchViewRoute,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeViewRoute, page: HomeView),
    RouteDef(Routes.groupViewRoute, page: GroupView),
    RouteDef(Routes.levelViewRoute, page: LevelView),
    RouteDef(Routes.cardMatchViewRoute, page: CardMatchView),
    RouteDef(Routes.infoViewRoute, page: InfoView),
    RouteDef(Routes.missingViewRoute, page: MissingView),
    RouteDef(Routes.scrambledViewRoute, page: ScrambledView),
    RouteDef(Routes.matchViewRoute, page: MatchView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    GroupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const GroupView(),
        settings: data,
      );
    },
    LevelView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LevelView(),
        settings: data,
      );
    },
    CardMatchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CardMatchView(),
        settings: data,
      );
    },
    InfoView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const InfoView(),
        settings: data,
      );
    },
    MissingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MissingView(),
        settings: data,
      );
    },
    ScrambledView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ScrambledView(),
        settings: data,
      );
    },
    MatchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MatchView(),
        settings: data,
      );
    },
  };
}

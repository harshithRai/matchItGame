/// ! ADD MORE ROUTES HERE...

import 'package:auto_route/auto_route_annotations.dart';

import '../ui/screens/cardMatch/cardMatchView.dart';
import '../ui/screens/group/groupView.dart';
import '../ui/screens/home/homeView.dart';
import '../ui/screens/info/infoView.dart';
import '../ui/screens/level/levelView.dart';
import '../ui/screens/missing/missingView.dart';
import '../ui/screens/scrambled/scrambledView.dart';
import '../ui/screens/match/matchView.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  MaterialRoute(page: HomeView, initial: true, name: 'homeViewRoute'),
  MaterialRoute(page: GroupView, name: 'groupViewRoute'),
  MaterialRoute(page: LevelView, name: 'levelViewRoute'),
  MaterialRoute(page: CardMatchView, name: 'cardMatchViewRoute'),
  MaterialRoute(page: InfoView, name: 'infoViewRoute'),
  MaterialRoute(page: MissingView, name: 'missingViewRoute'),
  MaterialRoute(page: ScrambledView, name: 'scrambledViewRoute'),
  MaterialRoute(page: MatchView, name: 'matchViewRoute'),
])
class $Router {}

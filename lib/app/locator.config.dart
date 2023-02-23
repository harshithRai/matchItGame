// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/analyticsService.dart';
import '../services/authenticationService.dart';
import '../services/connectivityService.dart';
import '../ui/screens/info/infoViewModel.dart';
import '../services/pushNotificationService.dart';
import '../services/storeService.dart';
import '../services/thirdPartyServicesModule.dart';
import '../services/userSelectionService.dart';
import '../services/utilitiesService.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<AuthenticationService>(() => AuthenticationService());
  gh.lazySingleton<DialogService>(() => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  gh.lazySingleton<StoreService>(() => StoreService());
  gh.lazySingleton<UserSelectionService>(() => UserSelectionService());
  gh.lazySingleton<UtilitiesService>(() => UtilitiesService());

  // Eager singletons must be registered in the right order
  gh.singleton<AnalyticsService>(AnalyticsService());
  gh.singleton<ConnectivityService>(ConnectivityService());
  gh.singleton<InfoViewModel>(InfoViewModel());
  gh.singleton<PushNotificationService>(PushNotificationService());
  return get;
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}

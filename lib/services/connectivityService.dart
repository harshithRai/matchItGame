import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:connectivity/connectivity.dart';
import '../constants/enums.dart';

@singleton
class ConnectivityService with ReactiveServiceMixin {
  RxValue<bool> _connectionStatus = RxValue<bool>(initial: true);

  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((event) {
      _getStatusFromResult(event);

      connectionStatusController.add(_getStatusFromResult(event));
    });
    listenToReactiveValues([_connectionStatus]);
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        _connectionStatus.value = true;
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        _connectionStatus.value = true;
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        _connectionStatus.value = false;
        return ConnectivityStatus.Offline;
      default:
        _connectionStatus.value = false;
        return ConnectivityStatus.Offline;
    }
  }

  bool get connectionStatus => _connectionStatus.value;
}

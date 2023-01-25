import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class DeviceConnectivityService with ChangeNotifier {
  // initial state
  bool _isConnectedToNetwork = false;

  // selectors
  bool get connectivityStatus => _isConnectedToNetwork;

  // reducers
  void changeConnectivityStatus({bool isConnected}) {
    _isConnectedToNetwork = isConnected;
    notifyListeners();
  }

  // check device current connection status on initial load
  void initializeConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _isConnectedToNetwork = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    notifyListeners();
  }

  // subscribe to device connection changes
  StreamSubscription checkChangeOfDeviceConnectionStatus(BuildContext context) {
    return Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) async {
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        changeConnectivityStatus(isConnected: true);
      } else if (connectivityResult == ConnectivityResult.none) {
        changeConnectivityStatus(isConnected: false);
      } else {
        changeConnectivityStatus(isConnected: false);
      }
    });
  }
}
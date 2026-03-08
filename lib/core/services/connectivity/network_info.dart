import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

// Provider
final networkInfoProvider = Provider<INetworkInfo>((ref) {
  return NetworkInfo(Connectivity());
});

class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  @override
  Future<bool> get isConnected async {
    // Step 1: check connectivity type
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isEmpty || connectivityResult.contains(ConnectivityResult.none) && connectivityResult.length == 1) {
      return false;
    }

    return await _hasInternetAccess();
  }

  Future<bool> _hasInternetAccess() async {
    if (kIsWeb) return true;
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}

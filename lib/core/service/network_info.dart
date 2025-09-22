import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';

abstract class NetworkBaseInfo {
  Future<bool> get isConnected;
  Stream<InternetConnectionStatus> get internetConnectionStream;
}

class NetworkInfo implements NetworkBaseInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfo(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> get internetConnectionStream {
    return connectionChecker.onStatusChange;
  }
}

/// Lightweight shim for Web to avoid using InternetAddress which is unsupported on Web.
/// Always assumes online (you can enhance later to listen to browser events).
class WebNetworkInfo implements NetworkBaseInfo {
  WebNetworkInfo();

  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<InternetConnectionStatus> get internetConnectionStream {
    // Emits nothing; consumers typically await isConnected when needed.
    return const Stream<InternetConnectionStatus>.empty();
  }
}

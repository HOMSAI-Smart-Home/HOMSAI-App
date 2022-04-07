import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';

abstract class NetworkManagerInterface {
  void subscribe(NetworkManagerSubscriber subscriber);

  void unsubscribe(NetworkManagerSubscriber subscriber);

  Future<bool> isConnect();

  Future<ConnectivityResult> getConnectionType();
}

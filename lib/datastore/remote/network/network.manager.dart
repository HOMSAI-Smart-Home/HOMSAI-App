import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';

class NetworkManagerSubscriber {
  Function(ConnectivityResult) onInernetChange;

  NetworkManagerSubscriber(this.onInernetChange);
}

class NetworkManagerSubscribersHandler {
  List<NetworkManagerSubscriber> subscribers = [];

  NetworkManagerSubscribersHandler();

  void subscribe(NetworkManagerSubscriber subscriber) {
    subscribers.add(subscriber);
  }

  void unsubscribe(NetworkManagerSubscriber subscriber) {
    subscribers.remove(subscriber);
  }

  void publish(ConnectivityResult change) {
    for (var subscriber in subscribers) {
      subscriber.onInernetChange(change);
    }
  }
}

class NetworkManager implements NetworkManagerInterface {
  NetworkManagerSubscribersHandler subscribersHandler =
      NetworkManagerSubscribersHandler();

  NetworkManager() {
    _listen();
  }

  @override
  void subscribe(NetworkManagerSubscriber subscriber) {
    subscribersHandler.subscribe(subscriber);
  }

  @override
  void unsubscribe(NetworkManagerSubscriber subscriber) {
    subscribersHandler.unsubscribe(subscriber);
  }

  void _listen() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      subscribersHandler.publish(result);
    });
  }

  @override
  Future<bool> isConnect() async {
    switch (await Connectivity().checkConnectivity()) {
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.wifi:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<ConnectivityResult> getConnectionType() async {
    return await Connectivity().checkConnectivity();
  }
}

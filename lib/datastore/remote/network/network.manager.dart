import 'package:connectivity_plus/connectivity_plus.dart';

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

class NetworkManager {
  NetworkManagerSubscribersHandler subscribersHandler =
      NetworkManagerSubscribersHandler();

  NetworkManager() {
    _listen();
  }

  void subscribe(NetworkManagerSubscriber subscriber) {
    subscribersHandler.subscribe(subscriber);
  }

  void unsubscribe(NetworkManagerSubscriber subscriber) {
    subscribersHandler.unsubscribe(subscriber);
  }

  void _listen() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      subscribersHandler.publish(result);
    });
  }
}

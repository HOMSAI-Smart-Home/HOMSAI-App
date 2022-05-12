import 'dart:async';

import 'package:homsai/datastore/DTOs/websocket/configuration/configuration_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/error/error.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/trigger/trigger_body.dto.dart';

abstract class WebSocketSubscriberInterface {
  Function(dynamic) onDone;
  Function(ErrorDto)? onError;

  WebSocketSubscriberInterface(
    this.onDone, {
    this.onError,
  });
}

abstract class WebSocketSubscribersHandlerInterface {
  void subscribe(WebSocketSubscriberInterface subscriber);

  void unsubscribe(WebSocketSubscriberInterface subscriber);

  void publish(dynamic result);
}

abstract class HomeAssistantWebSocketInterface {
  bool isConnected();
  bool isConnecting();

  Future<void> connect({
    Uri? url,
    Function? onConnected,
  });

  Future<void> reconnect({
    Function? onConnected,
  });

  Future<void> logout();

  void removeSubscription(
    String event,
    WebSocketSubscriberInterface subscriber,
  );

  ///////////////////
  // Subscriptions
  ///////////////////

  void subscribeEvent(
    String event,
    WebSocketSubscriberInterface subscriber,
  );

  void subscribeTrigger(
    String event,
    WebSocketSubscriberInterface subscriber,
    TriggerBodyDto trigger,
  );

  void unsubscribingFromEvents(
    String event,
    WebSocketSubscriberInterface subscriber,
  );

  void fireAnEvent(
    WebSocketSubscriberInterface subscriber,
    String eventType, {
    Map<String, String>? eventData,
  });

  void callingAService(
    WebSocketSubscriberInterface subscriber,
    String domain,
    String service,
    ServiceBodyDto serviceBodyDto,
  );

  void fetchingStates(WebSocketSubscriberInterface subscriber);

  void fetchingConfig(WebSocketSubscriberInterface subscriber);

  void fetchingServices(WebSocketSubscriberInterface subscriber);

  void fetchingMediaPlayerThumbnails(
    WebSocketSubscriberInterface subscriber,
    String entityId,
  );

  void validateConfig(
    WebSocketSubscriberInterface subscriber,
    String entityId,
    ConfigurationBodyDto configurationBodyDto,
  );
}

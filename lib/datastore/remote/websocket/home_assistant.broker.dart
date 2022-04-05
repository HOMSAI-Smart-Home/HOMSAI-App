import 'package:get_it/get_it.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/websocket/change/change.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/response/response.dto.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/main.dart';

class BrokerSubscriber {
  Function(dynamic) onDone;

  BrokerSubscriber(this.onDone);
}

class BrokerSubscribersHandler {
  final List<BrokerSubscriber> _subscribersWithoutId = [];
  final Map<String, BrokerSubscriber> _subscribersWithId = {};

  void subscribe(BrokerSubscriber subscriber, {Entity? entityId}) {
    entityId == null
        ? _subscribersWithoutId.add(subscriber)
        : _subscribersWithId[entityId.entityId] = subscriber;
  }

  void unsubscribe(BrokerSubscriber subscriber, {Entity? entityId}) {
    entityId == null
        ? _subscribersWithoutId.remove(subscriber)
        : _subscribersWithId.remove(entityId.entityId);
  }

  void publish(dynamic result, {String? id}) {
    if (result == null) return;

    if (id == null) {
      for (var element in _subscribersWithoutId) {
        element.onDone(result);
      }
    } else {
      print(id);
      print(_subscribersWithId);
      _subscribersWithId[id]!.onDone(result);
    }
  }
}

class HomeAssistantBroker {
  HomeAssistantWebSocketRepository? webSocket;
  Map<String, BrokerSubscribersHandler> eventHandler = {};

  void connect() {
    webSocket = getIt.get<HomeAssistantWebSocketRepository>();
    webSocket!.subscribeEvent(HomeAssistantApiProprties.eventStateChanged,
        WebSocketSubscriber(onChange));
  }

  void subscribeOnChange(Entity entityId, Function(dynamic) onChange) {
    if (!eventHandler
        .containsKey(HomeAssistantApiProprties.eventStateChanged)) {
      eventHandler[HomeAssistantApiProprties.eventStateChanged] =
          BrokerSubscribersHandler();
    }

    eventHandler[HomeAssistantApiProprties.eventStateChanged]
        ?.subscribe(BrokerSubscriber(onChange), entityId: entityId);
  }

  void onChange(dynamic result) {
    ChangeDto changeDto;

    changeDto = ChangeDto.fromJson(result);

    //TODO: remove this filter
    if (!changeDto.data.entityId.contains("light.")) return;

    print("yoo");
    print(result);

    eventHandler[HomeAssistantApiProprties.eventStateChanged]
        ?.publish(changeDto.data.newState, id: changeDto.data.entityId);
  }
}

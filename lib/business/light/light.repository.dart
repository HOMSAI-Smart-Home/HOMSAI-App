import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant.broker.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';

import 'light.interface.dart';

class LightRepository extends LightRepositoryInterface {
  HomeAssistantWebSocketInterface webSocket =
      getIt.get<HomeAssistantWebSocketInterface>();
  HomeAssistantBroker homeAssistantBroker = getIt.get<HomeAssistantBroker>();

  @override
  void toggle(LightEntity light) {
    if (light.isOn) {
      turnOff(light);
    } else {
      turnOn(light);
    }
  }

  @override
  void turnOff(LightEntity light) {
    webSocket.callingAService(
        WebSocketSubscriber(
          (data) {},
          onError: (error) => print(error),
        ),
        'light',
        'turn_off',
        ServiceBodyDto(light.toJson(), {
          'entity_id': light.entityId,
          'device_id': light.context.id,
        }));
  }

  @override
  void turnOn(LightEntity light) {
    webSocket.callingAService(
        WebSocketSubscriber(
          (data) {},
          onError: (error) => print(error),
        ),
        'light',
        'turn_on',
        ServiceBodyDto(light.toJson(), {
          'entity_id': light.entityId,
          'device_id': light.context.id,
        }));
  }

  @override
  void onChanged(Entity entity, Function(LightEntity) onchanged) {
    homeAssistantBroker.subscribeOnChange(entity, (entity) {
      onchanged(LightEntity.fromJson(entity));
    });
  }
}

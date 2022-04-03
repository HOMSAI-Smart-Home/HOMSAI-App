import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';

import 'light.interface.dart';

class LightRepository extends LightRepositoryInterface {
  HomeAssistantWebSocketRepository webSocket =
      getIt.get<HomeAssistantWebSocketRepository>();

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
        Subscriber((data) => light.turnOff(), onError: (error) => print(error)),
        'light',
        'turn_off',
        ServiceBodyDto(light.toJson(), {
          'entity_id': light.entityId,
          'device_id': light.context.id,
        }));
    light.turnOff();
  }

  @override
  void turnOn(LightEntity light) {
    webSocket.callingAService(
        Subscriber((data) => light.turnOn(), onError: (error) => print(error)),
        'light',
        'turn_on',
        ServiceBodyDto(light.toJson(), {
          'entity_id': light.entityId,
          'device_id': light.context.id,
        }));
    light.turnOn();
  }
}

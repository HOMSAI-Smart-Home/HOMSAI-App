import 'package:homsai/business/repository/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/DTOs/websocket/serviceBody.dto.dart';
import 'package:homsai/datastore/models/entity/light.entity.dart';
import 'package:homsai/main.dart';

class LightRepository {
  HomeAssistantWebSocketRepository webSocket =
      getIt.get<HomeAssistantWebSocketRepository>();

  void toggle(LightEntity light) {
    if (light.isOn) {
      turnOff(light);
    } else {
      turnOn(light);
    }
  }

  void turnOff(LightEntity light) {
    webSocket.callingAService(
        Subscriber((data) => light.isOn = true,
            onError: (error) => print(error)),
        'light',
        'turn_off',
        ServiceBodyDto(light.toJson(), {
          'entity_id': light.entityId,
          'device_id': light.id,
        }));
    light.turnOff();
  }

  void turnOn(LightEntity light) {
    webSocket.callingAService(
        Subscriber((data) => light.isOn = true,
            onError: (error) => print(error)),
        'light',
        'turn_on',
        ServiceBodyDto(light.toJson(), {
          'entity_id': light.entityId,
          'device_id': light.id,
        }));
    light.turnOn();
  }
}

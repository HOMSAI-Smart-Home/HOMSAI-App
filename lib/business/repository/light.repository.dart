import 'package:homsai/business/repository/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/DTOs/websocket/serviceBody.dto.dart';
import 'package:homsai/datastore/models/entity/light.entity.dart';
import 'package:homsai/main.dart';

class LightRepository {
  HomeAssistantWebSocketRepository webSocket =
      getIt.get<HomeAssistantWebSocketRepository>();

  late LightEntity lightEntity;

  LightRepository.fromJson(Map<String, dynamic> entity) {
    lightEntity = LightEntity.fromJson(entity);
  }

  void toggle() {
    if (lightEntity.isOn == null || lightEntity.isOn!) {
      turnOff();
    } else {
      turnOn();
    }
  }

  void turnOff() {
    webSocket.callingAService(
        Subscriber((data) => lightEntity.isOn = true,
            onError: (error) => print(error)),
        'light',
        'turn_off',
        ServiceBodyDto(
            lightEntity.toJson(), {'entity_id': lightEntity.entityId}));
    lightEntity.turnOff();
  }

  void turnOn() {
    webSocket.callingAService(
        Subscriber((data) => lightEntity.isOn = true,
            onError: (error) => print(error)),
        'light',
        'turn_on',
        ServiceBodyDto(
            lightEntity.toJson(), {'entity_id': lightEntity.entityId}));
    lightEntity.turnOff();
  }
}

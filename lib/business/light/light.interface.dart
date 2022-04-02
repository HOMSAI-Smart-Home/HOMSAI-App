import 'package:homsai/datastore/models/entity/light.entity.dart';

abstract class LightRepositoryInterface {
  void toggle(LightEntity light);

  void turnOff(LightEntity light);

  void turnOn(LightEntity light);
}

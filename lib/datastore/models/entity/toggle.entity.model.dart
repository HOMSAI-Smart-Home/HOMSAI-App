import 'package:homsai/datastore/models/entity/entity.entity.model.dart';

abstract class ToggleEntity implements Entity {
  bool? isOn;

  void turnOn() {
    isOn = true;
  }

  void turnOff() {
    isOn = false;
  }
}

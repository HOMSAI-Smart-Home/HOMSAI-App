import 'package:homsai/datastore/models/entity/entity.entity.model.dart';

abstract class ToggleEntity  implements Entity{
  bool? isOn;

  void turnOn();

  void turnOff();

  void toggle();
}

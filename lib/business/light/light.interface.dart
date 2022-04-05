import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';

abstract class LightRepositoryInterface {
  void toggle(LightEntity light);

  void turnOff(LightEntity light);

  void turnOn(LightEntity light);
  
  void onChanged(Entity entity, Function(LightEntity) onchanged);
}

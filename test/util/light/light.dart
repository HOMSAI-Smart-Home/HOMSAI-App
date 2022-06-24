import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/business/light/light.interface.dart';
import 'package:homsai/business/light/light.repository.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'light.mocks.dart';

@GenerateMocks([LightRepository])
class MocksLightRepository {
  static final MockLightRepository _mockLight = MockLightRepository();

  static Future<void> setUp() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<LightRepositoryInterface>(() => _mockLight);
    mockOnChanged();
  }

  static mockLightOn(
      LightEntity lightEntity, void Function(LightEntity) callback) {
    when(_mockLight.turnOn(any)).thenAnswer((_) {
      final light = lightEntity.copy();
      light.state = "on";
      _mockLight.onChanged(light, callback);
    });
  }

  static mockLightOff(
      LightEntity lightEntity, void Function(LightEntity) callback) {
    when(_mockLight.turnOn(any)).thenAnswer((_) {
      final light = lightEntity.copy();
      light.state = "off";
      _mockLight.onChanged(light, callback);
    });
  }

  static mockOnChanged() {
    when(_mockLight.onChanged(any, any)).thenAnswer((invocation) {
      final callback = invocation.positionalArguments[1];
      if (callback != null) {
        callback(invocation.positionalArguments[0]);
      }
    });
  }
}

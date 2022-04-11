import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_sensor.factory.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:homsai/main.dart';

part 'add_sensor.event.dart';
part 'add_sensor.state.dart';

class AddSensorBloc extends Bloc<AddSensorEvent, AddSensorState> {
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  AddSensorBloc() : super(const AddSensorState()) {
    on<RetrieveSensors>(_onRetrieveSensors);
    on<ProductionSensorChanged>(_onProductionSensorChanged);
    on<ConsumptionSensorChanged>(_onConsumptionSensorChanged);
    on<OnSubmit>(_onSubmit);
    add(RetrieveSensors());
  }

  @override
  void onTransition(Transition<AddSensorEvent, AddSensorState> transition) {
    super.onTransition(transition);
  }

  void _onRetrieveSensors(
      RetrieveSensors event, Emitter<AddSensorState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    if (plant != null) {
      final sensors =
          await appDatabase.plantDao.getEntities<SensorEntity>(plant.id!);
      final powerSensors = sensors
          .filterSensorByDeviceClass<MesurableSensorEntity>(DeviceClass.power);
      emit(state.copyWith(
        productionSensors: List<MesurableSensorEntity>.from(powerSensors),
        consumptionSensors: List<MesurableSensorEntity>.from(powerSensors),
      ));
    }
  }

  void _onProductionSensorChanged(
      ProductionSensorChanged event, Emitter<AddSensorState> emit) {
    emit(state.copyWith(
      selectedProductionSensor: event.sensor,
    ));
  }

  void _onConsumptionSensorChanged(
      ConsumptionSensorChanged event, Emitter<AddSensorState> emit) {
    emit(state.copyWith(
      selectedConsumptionSensor: event.sensor,
    ));
  }

  void _onSubmit(OnSubmit event, Emitter<AddSensorState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    final newPlant = plant?.copyWith(
      productionSensor: state.selectedProductionSensor?.entityId,
      consumptionSensor: state.selectedConsumptionSensor?.entityId,
    );
    if (newPlant != null) {
      appDatabase.plantDao.updateItem(newPlant);
    }
    event.onSubmit();
  }
}

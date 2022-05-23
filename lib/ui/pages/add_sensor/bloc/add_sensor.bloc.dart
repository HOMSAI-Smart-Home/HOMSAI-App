import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/components/utils/month_year_field/bloc/month_year_field.bloc.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_sensor.factory.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';

part 'add_sensor.event.dart';
part 'add_sensor.state.dart';

class AddSensorBloc extends Bloc<AddSensorEvent, AddSensorState> {
  final AppDatabase appDatabase = getIt.get<AppDatabase>();
  final HomeAssistantWebSocketInterface webSocketRepository =
      getIt.get<HomeAssistantWebSocketInterface>();
  final WebSocketBloc webSocketBloc;
  final Uri? url;

  AddSensorBloc(this.webSocketBloc, this.url) : super(const AddSensorState()) {
    on<ProductionSensorChanged>(_onProductionSensorChanged);
    on<EntitiesFetched>(_onEntitiesFetched);
    on<ConsumptionSensorChanged>(_onConsumptionSensorChanged);
    on<PhotovoltaicNominalPowerChanged>(_onPhotovoltaicNominalPowerChanged);
    on<PhotovoltaicInstallatioDateChanged>(
        _onPhotovoltaicInstallatioDateChanged);
    on<OnSubmit>(_onSubmit);
    if (!webSocketRepository.isConnected()) {
      webSocketBloc.add(ConnectWebSocket(
        onWebSocketConnected: () {
          webSocketBloc.add(FetchEntites(
            onEntitiesFetched: (entities) => add(EntitiesFetched(entities)),
          ));
        },
      ));
    } else {
      webSocketBloc.add(FetchEntites(
        onEntitiesFetched: (entities) => add(EntitiesFetched(entities)),
      ));
    }
  }

  @override
  void onTransition(Transition<AddSensorEvent, AddSensorState> transition) {
    super.onTransition(transition);
  }

  void _onEntitiesFetched(
      EntitiesFetched event, Emitter<AddSensorState> emit) async {
    SensorEntity? consumptionSensor;
    SensorEntity? productionSensor;
    final plant = await appDatabase.getPlant();
    if (plant != null) {
      if (event.entities.isNotEmpty) {
        await appDatabase.homeAssitantDao.insertEntities(
          plant.id!,
          event.entities,
        );
      }
      if (plant.consumptionSensor != null) {
        consumptionSensor =
            await appDatabase.getEntity<SensorEntity>(plant.consumptionSensor!);
      }
      if (plant.productionSensor != null) {
        productionSensor =
            await appDatabase.getEntity<SensorEntity>(plant.productionSensor!);
      }
      if (consumptionSensor != null && productionSensor != null) {
        emit(
          state.copyWith(
              selectedConsumptionSensor:
                  consumptionSensor as MesurableSensorEntity,
              selectedProductionSensor:
                  productionSensor as MesurableSensorEntity,
              initialPhotovoltaicNominalPower: plant.photovoltaicNominalPower,
              initialPhotovoltaicInstallationDate:
                  parseMonthYearString(plant.photovoltaicInstallationDate),
              photovoltaicInstallationDate: plant.photovoltaicInstallationDate),
        );
      }
    }

    final sensors = event.entities.getEntities<SensorEntity>();
    final powerSensors = sensors
        .filterSensorByDeviceClass<MesurableSensorEntity>(DeviceClass.power);
    emit(
      state.copyWith(
          productionSensors: List<MesurableSensorEntity>.from(powerSensors),
          consumptionSensors: List<MesurableSensorEntity>.from(powerSensors),
          initialPhotovoltaicNominalPower: plant?.photovoltaicNominalPower,
          initialPhotovoltaicInstallationDate:
              parseMonthYearString(plant?.photovoltaicInstallationDate),
          photovoltaicInstallationDate: plant?.photovoltaicInstallationDate),
    );
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

  void _onPhotovoltaicNominalPowerChanged(
      PhotovoltaicNominalPowerChanged event, Emitter<AddSensorState> emit) {
    emit(state.copyWith(photovoltaicNominalPower: event.value));
  }

  void _onPhotovoltaicInstallatioDateChanged(
      PhotovoltaicInstallatioDateChanged event, Emitter<AddSensorState> emit) {
    final date = parseMonthYearDate(event.date);
    emit(
      state.copyWith(
          photovoltaicInstallationDate:
              date != null && checkMonthYearDate(event.date, date)
                  ? date
                  : null),
    );
  }

  void _onSubmit(OnSubmit event, Emitter<AddSensorState> emit) async {
    final plant = await appDatabase.getPlant();
    final newPlant = plant?.copyWith(
      productionSensor: state.selectedProductionSensor?.entityId,
      consumptionSensor: state.selectedConsumptionSensor?.entityId,
      photovoltaicInstallationDate: state.photovoltaicInstallationDate,
      photovoltaicNominalPower: state.photovoltaicNominalPower,
    );
    if (newPlant != null) {
      await appDatabase.plantDao.updateItem(newPlant);
    }
    event.onSubmit();
  }
}

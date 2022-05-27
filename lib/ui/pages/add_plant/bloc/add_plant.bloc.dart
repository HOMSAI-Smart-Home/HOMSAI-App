import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/helpers/models/forms/add_plant/coordinate.model.dart';
import 'package:homsai/crossconcern/helpers/models/forms/add_plant/plant_name.model.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';
import 'package:timezone/timezone.dart';

part 'add_plant.event.dart';
part 'add_plant.state.dart';

class AddPlantBloc extends Bloc<AddPlantEvent, AddPlantState> {
  final HomeAssistantWebSocketInterface webSocketRepository =
      getIt.get<HomeAssistantWebSocketInterface>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();
  final WebSocketBloc webSocketBloc;
  final bool wizard;

  AddPlantBloc(this.webSocketBloc, String? baseUrl, String? fallback, this.wizard,)
      : super(const AddPlantState()) {
    on<ConfigurationFetched>(_onConfigurationFetched);
    on<FetchLocalConfig>(_onFetchLocalConfig);
    on<PlantNameChanged>(_onPlantNameChanged);
    on<PlantNameUnfocused>(_onPlantNameUnfocused);
    on<CoordinateChanged>(_onCoordinateChanged);
    on<CoordinateUnfocused>(_onCoordinateUnfocused);
    on<OnSubmit>(_onSubmit);
    if (wizard) {
      webSocketBloc.add(
        ConnectWebSocket(
          onWebSocketConnected: () {
            webSocketBloc.add(
              FetchConfig(
                onConfigurationFetched: (config) {
                  add(ConfigurationFetched(Configuration.fromDto(config)));
                },
              ),
            );
          },
          baseUrl: baseUrl ?? '',
          fallback: fallback ?? '',
        ),
      );
    } else {
      add(FetchLocalConfig());
    }
  }

  @override
  void onTransition(Transition<AddPlantEvent, AddPlantState> transition) {
    super.onTransition(transition);
  }

  void _onConfigurationFetched(
      ConfigurationFetched event, Emitter<AddPlantState> emit) {
    final plantName = PlantName.dirty(event.configuration.locationName);
    final coordinate = Coordinate.dirty(
        "${event.configuration.latitude.toStringAsFixed(5)};${event.configuration.longitude.toStringAsFixed(5)}");
    getIt
        .registerSingleton<Location>(getLocation(event.configuration.timezone));
    emit(state.copyWith(
        plantName: plantName,
        initialPlantName: plantName.value,
        coordinate: coordinate,
        configuration: event.configuration));
  }

  void _onFetchLocalConfig(
      FetchLocalConfig event, Emitter<AddPlantState> emit) async {
    final plant = await appDatabase.getPlant();
    if (plant != null) {
      emit(state.copyWith(
          plantName: PlantName.dirty(plant.name),
          initialPlantName: plant.name,
          coordinate: Coordinate.dirty(
              "${plant.latitude.toStringAsFixed(5)};${plant.longitude.toStringAsFixed(5)}"),
          configuration: null));
    } else {
      final config = await appDatabase.getConfiguration();
      if (config != null) {
        add(ConfigurationFetched(config));
      }
    }
  }

  void _onPlantNameChanged(
      PlantNameChanged event, Emitter<AddPlantState> emit) {
    final plantName = PlantName.dirty(event.plantName);
    emit(state.copyWith(
      plantName: plantName.valid ? plantName : PlantName.pure(event.plantName),
      status: _isFormValidate(plantName: plantName),
    ));
  }

  void _onPlantNameUnfocused(
    PlantNameUnfocused event,
    Emitter<AddPlantState> emit,
  ) {
    final plantName = PlantName.dirty(event.plantName);
    emit(state.copyWith(
      plantName: plantName,
      status: _isFormValidate(plantName: plantName),
    ));
  }

  void _onCoordinateChanged(
      CoordinateChanged event, Emitter<AddPlantState> emit) {
    final coordinate = Coordinate.dirty(event.coordinate);
    emit(state.copyWith(
      coordinate:
          coordinate.valid ? coordinate : Coordinate.pure(event.coordinate),
      status: _isFormValidate(coordinate: coordinate),
    ));
  }

  void _onCoordinateUnfocused(
    CoordinateUnfocused event,
    Emitter<AddPlantState> emit,
  ) {
    final coordinate = Coordinate.dirty(event.coordinate);
    emit(state.copyWith(
      coordinate: coordinate,
      status: _isFormValidate(coordinate: coordinate),
    ));
  }

  void _onSubmit(OnSubmit event, Emitter<AddPlantState> emit) async {
    Plant? plant = await appDatabase.getPlant();

    List<String> coordinates = state.coordinate.value.split(";");
    final latitude = coordinates.first;
    final longitude = coordinates.last;

    if (plant != null) {
      plant = plant.copyWith(
        name: state.plantName.value,
        latitude: double.parse(latitude),
        longitude: double.parse(longitude),
      );
    } else {
      final configurationId =
          await appDatabase.configurationDao.insertItem(state.configuration!);
      plant = Plant(
        event.localUrl.isNotEmpty ? event.localUrl : null,
        event.remoteUrl.isNotEmpty ? event.remoteUrl : null,
        state.plantName.value,
        double.parse(latitude),
        double.parse(longitude),
        configurationId,
      );
    }

    final plantId = await appDatabase.plantDao.insertPlantReplace(plant);
    await appDatabase.updatePlant(plantId);
    event.onSubmit();
  }

  FormzStatus _isFormValidate({
    PlantName? plantName,
    Coordinate? coordinate,
  }) {
    return Formz.validate(
        [plantName ?? state.plantName, coordinate ?? state.coordinate]);
  }
}

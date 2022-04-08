import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/helpers/models/forms/add_plant/coordinate.model.dart';
import 'package:homsai/crossconcern/helpers/models/forms/add_plant/plant_name.model.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/main.dart';

part 'add_plant.event.dart';
part 'add_plant.state.dart';

class AddPlantBloc extends Bloc<AddPlantEvent, AddPlantState> {
  final HomeAssistantWebSocketRepository webSocketRepository =
      getIt.get<HomeAssistantWebSocketRepository>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  AddPlantBloc() : super(const AddPlantState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchConfig>(_onFetchConfig);
    on<FetchedConfig>(_onFetchedConfig);
    on<PlantNameChanged>(_onPlantNameChanged);
    on<PlantNameUnfocused>(_onPlantNameUnfocused);
    on<CoordinateChanged>(_onCoordinateChanged);
    on<CoordinateUnfocused>(_onCoordinateUnfocused);
    on<OnSubmit>(_onSubmit);
  }

  @override
  void onTransition(Transition<AddPlantEvent, AddPlantState> transition) {
    super.onTransition(transition);
  }

  void _onWebsocketConnect(
      ConnectWebSocket event, Emitter<AddPlantState> emit) async {
    HomeAssistantAuth? auth = appPreferencesInterface.getToken();
    if (auth?.url != null) {
      webSocketRepository.connect(Uri.parse(auth!.url));
    }
  }

  void _onFetchConfig(FetchConfig event, Emitter<AddPlantState> emit) {
    webSocketRepository.fetchingConfig(
      WebSocketSubscriber(
        (data) {
          add(FetchedConfig(ConfigurationDto.fromJson(data)));
        },
      ),
    );
  }

  void _onFetchedConfig(FetchedConfig event, Emitter<AddPlantState> emit) {
    final plantName = PlantName.dirty(event.configuration.locationName);
    final coordinate = Coordinate.dirty(
        "${event.configuration.latitude};${event.configuration.longitude}");
    emit(state.copyWith(
        plantName: plantName,
        coordinate: coordinate,
        configuration: Configuration.fromDto(event.configuration)));
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
    HomeAssistantAuth? auth = appPreferencesInterface.getToken();
    List<String> coordinates = state.coordinate.value.split(";");
    final latitude = coordinates.first;
    final longitude = coordinates.last;
    final configurationId =
        await appDatabase.configurationDao.insertItem(state.configuration!);
    final plantId = await appDatabase.plantDao.insertItem(Plant(
      (auth?.url ?? ""),
      state.plantName.value,
      "",
      double.parse(latitude),
      double.parse(longitude),
      configurationId,
    ));
    await appDatabase.plantDao.setActive(plantId);
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

part of 'add_plant.bloc.dart';

abstract class AddPlantEvent extends Equatable {
  const AddPlantEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends AddPlantEvent {}

class FetchConfig extends AddPlantEvent {}

class FetchedConfig extends AddPlantEvent {
  const FetchedConfig(this.configuration);

  final ConfigurationDto configuration;

  @override
  List<Object> get props => [configuration];
}

class PlantNameChanged extends AddPlantEvent {
  const PlantNameChanged(this.plantName);

  final String plantName;

  @override
  List<Object> get props => [plantName];
}

class PlantNameUnfocused extends AddPlantEvent {
  const PlantNameUnfocused(this.plantName);

  final String plantName;

  @override
  List<Object> get props => [plantName];
}

class CoordinateChanged extends AddPlantEvent {
  const CoordinateChanged(this.coordinate);

  final String coordinate;

  @override
  List<Object> get props => [coordinate];
}

class CoordinateUnfocused extends AddPlantEvent {
  const CoordinateUnfocused(this.coordinate);

  final String coordinate;

  @override
  List<Object> get props => [coordinate];
}

class OnSubmit extends AddPlantEvent {
  const OnSubmit(this.onSubmit);

  final void Function() onSubmit;

  @override
  List<Object> get props => [onSubmit];
}

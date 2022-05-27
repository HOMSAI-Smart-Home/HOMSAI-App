part of 'add_plant.bloc.dart';

abstract class AddPlantEvent extends Equatable {
  const AddPlantEvent();

  @override
  List<Object> get props => [];
}

class ConfigurationFetched extends AddPlantEvent {
  const ConfigurationFetched(this.configuration);

  final Configuration configuration;

  @override
  List<Object> get props => [configuration];
}

class FetchLocalConfig extends AddPlantEvent {
  // Empty
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
  const OnSubmit(this.onSubmit, this.localUrl, this.remoteUrl);

  final void Function() onSubmit;
  final String localUrl;
  final String remoteUrl;

  @override
  List<Object> get props => [onSubmit, localUrl, remoteUrl];
}

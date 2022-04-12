part of 'add_plant.bloc.dart';

class AddPlantState extends Equatable {
  const AddPlantState({
    this.plantName = const PlantName.pure(),
    this.initialPlantName = "",
    this.coordinate = const Coordinate.pure(),
    this.entities = const [],
    this.configuration,
    this.status = FormzStatus.pure,
  });

  final PlantName plantName;
  final String initialPlantName;
  final Coordinate coordinate;
  final Configuration? configuration;
  final List<Entity> entities;
  final FormzStatus status;

  AddPlantState copyWith({
    PlantName? plantName,
    String? initialPlantName,
    Coordinate? coordinate,
    Configuration? configuration,
    List<Entity>? entities,
    FormzStatus? status,
  }) {
    return AddPlantState(
      plantName: plantName ?? this.plantName,
      initialPlantName: initialPlantName ?? this.initialPlantName,
      coordinate: coordinate ?? this.coordinate,
      entities: entities ?? this.entities,
      configuration: configuration ?? this.configuration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props =>
      [plantName, initialPlantName, coordinate, entities, status];
}

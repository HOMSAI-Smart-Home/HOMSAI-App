part of 'add_plant.bloc.dart';

class AddPlantState extends Equatable {
  const AddPlantState({
    this.email = const Email.pure(),
    this.plantName = const PlantName.pure(),
    this.coordinate = const Coordinate.pure(),
    this.entities = const [],
    this.configuration,
    this.status = FormzStatus.pure,
  });

  final Email email;
  final PlantName plantName;
  final Coordinate coordinate;
  final Configuration? configuration;
  final List<Entity> entities;
  final FormzStatus status;

  AddPlantState copyWith({
    Email? email,
    PlantName? plantName,
    Coordinate? coordinate,
    Configuration? configuration,
    List<Entity>? entities,
    FormzStatus? status,
  }) {
    return AddPlantState(
      email: email ?? this.email,
      plantName: plantName ?? this.plantName,
      coordinate: coordinate ?? this.coordinate,
      entities: entities ?? this.entities,
      configuration: configuration ?? this.configuration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, plantName, coordinate, entities, status];
}

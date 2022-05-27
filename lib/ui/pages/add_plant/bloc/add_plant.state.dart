part of 'add_plant.bloc.dart';

class AddPlantState extends Equatable {
  const AddPlantState({
    this.plantName = const PlantName.pure(),
    this.initialPlantName = "",
    this.coordinate = const Coordinate.pure(),
    this.configuration,
    this.status = FormzStatus.pure,
  });

  final PlantName plantName;
  final String initialPlantName;
  final Coordinate coordinate;
  final Configuration? configuration;
  final FormzStatus status;

  AddPlantState copyWith({
    PlantName? plantName,
    String? initialPlantName,
    Coordinate? coordinate,
    Configuration? configuration,
    FormzStatus? status,
  }) {
    return AddPlantState(
      plantName: plantName ?? this.plantName,
      initialPlantName: initialPlantName ?? this.initialPlantName,
      coordinate: coordinate ?? this.coordinate,
      configuration: configuration ?? this.configuration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props =>
      [plantName, initialPlantName, coordinate, status];
}

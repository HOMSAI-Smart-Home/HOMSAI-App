part of 'add_plant.bloc.dart';

class AddPlantState extends Equatable {
  const AddPlantState({
    this.plantName = const PlantName.pure(),
    this.coordinate = const Coordinate.pure(),
    this.status = FormzStatus.pure,
  });

  final PlantName plantName;
  final Coordinate coordinate;
  final FormzStatus status;

  AddPlantState copyWith({
    PlantName? plantName,
    Coordinate? coordinate,
    FormzStatus? status,
  }) {
    return AddPlantState(
      plantName: plantName ?? this.plantName,
      coordinate: coordinate ?? this.coordinate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [plantName, coordinate, status];
}

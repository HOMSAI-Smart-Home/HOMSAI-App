part of 'add_plant.bloc.dart';

abstract class AddPlantEvent extends Equatable {
  const AddPlantEvent();

  @override
  List<Object> get props => [];
}

class RetrieveToken extends AddPlantEvent {}

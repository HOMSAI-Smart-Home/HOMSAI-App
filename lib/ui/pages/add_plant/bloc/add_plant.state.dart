part of 'add_plant.bloc.dart';

class AddPlantState extends Equatable {
  const AddPlantState({
    this.token,
  });

  final String? token;

  AddPlantState copyWith({
    String? token,
  }) {
    return AddPlantState(token: token ?? this.token);
  }

  @override
  List<Object> get props => [token ?? ""];
}

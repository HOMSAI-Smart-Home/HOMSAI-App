part of 'home.bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends HomeEvent {}

class FetchStates extends HomeEvent {}

class FetchedLights extends HomeEvent {
  const FetchedLights({required this.entities});

  final List<dynamic> entities;

  @override
  List<Object> get props => [entities];
}

class FetchHistory extends HomeEvent {}

class ToggleConsumptionOptimazedPlot extends HomeEvent {
  const ToggleConsumptionOptimazedPlot({required this.isOptimized});

  final bool isOptimized;

  @override
  List<Object> get props => [isOptimized];
}

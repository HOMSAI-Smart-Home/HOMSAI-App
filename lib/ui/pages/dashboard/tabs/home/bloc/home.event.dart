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

class LightOn extends HomeEvent {
  const LightOn({required this.light});

  final LightEntity light;

  @override
  List<Object> get props => [light];
}

class LightOff extends HomeEvent {
  const LightOff({required this.light});

  final LightEntity light;

  @override
  List<Object> get props => [light];
}

part of 'intro_beta.bloc.dart';

abstract class IntroBetaEvent extends Equatable {
  const IntroBetaEvent();

  @override
  List<Object> get props => [];
}

class ConfigurationFetched extends IntroBetaEvent {
  const ConfigurationFetched(this.configuration);

  final ConfigurationDto configuration;

  @override
  List<Object> get props => [configuration];
}

class StatesFetched extends IntroBetaEvent {
  const StatesFetched(this.entities);

  final List<Entity> entities;

  @override
  List<Object> get props => [entities];
}

class EmailChanged extends IntroBetaEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class EmailUnfocused extends IntroBetaEvent {}

class PlantNameChanged extends IntroBetaEvent {
  const PlantNameChanged(this.plantName);

  final String plantName;

  @override
  List<Object> get props => [plantName];
}

class OnSubmit extends IntroBetaEvent {
  const OnSubmit(this.onSubmit);

  final void Function() onSubmit;

  @override
  List<Object> get props => [onSubmit];
}

part of 'home.bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.lights = const []});

  final List<LightEntity> lights;

  HomeState copyWith({
    List<LightEntity>? lights,
  }) {
    return HomeState(lights: lights ?? this.lights);
  }

  @override
  List<Object?> get props => [lights];
}

part of 'light_device.bloc.dart';

class LightDeviceState extends Equatable {
  const LightDeviceState({required this.light});

  final LightEntity light;

  LightDeviceState copyWith({
    LightEntity? light,
  }) {
    return LightDeviceState(light: light ?? this.light);
  }

  @override
  List<Object?> get props => [light];
}

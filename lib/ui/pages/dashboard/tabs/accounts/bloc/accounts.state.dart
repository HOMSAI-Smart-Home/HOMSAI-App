part of 'accounts.bloc.dart';

class AccountsState extends Equatable {
  const AccountsState({
    this.localUrl,
    this.remoteUrl,
    this.consumptionSensor,
    this.productionSensor,
    this.batterySensor,
    this.plantName,
    this.position,
    this.email,
    this.version,
  });

  final String? localUrl;
  final String? remoteUrl;
  final String? consumptionSensor;
  final String? productionSensor;
  final String? batterySensor;
  final String? plantName;
  final String? position;
  final String? email;
  final String? version;

  AccountsState copyWith({
    String? localUrl,
    String? remoteUrl,
    String? consumptionSensor,
    String? productionSensor,
    String? batterySensor,
    String? plantName,
    String? position,
    String? email,
    String? version,
  }) {
    return AccountsState(
      localUrl: localUrl == null
          ? this.localUrl
          : localUrl.isEmpty
              ? null
              : localUrl,
      remoteUrl: remoteUrl == null
          ? this.remoteUrl
          : remoteUrl.isEmpty
              ? null
              : remoteUrl,
      consumptionSensor: consumptionSensor ?? this.consumptionSensor,
      productionSensor: productionSensor ?? this.productionSensor,
      batterySensor: batterySensor ?? this.batterySensor,
      plantName: plantName ?? this.plantName,
      position: position ?? this.position,
      email: email ?? this.email,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
        localUrl,
        remoteUrl,
        consumptionSensor,
        productionSensor,
        batterySensor,
        plantName,
        position,
        email,
        version,
      ];
}

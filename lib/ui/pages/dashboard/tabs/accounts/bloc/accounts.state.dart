part of 'accounts.bloc.dart';

class AccountsState extends Equatable {
  const AccountsState({
    this.localUrl = 'http://:192.168.x.x:8123',
    this.remoteUrl = 'http://:192.168.x.x:8123',
    this.consumptionSensor = '[xxx]',
    this.productionSensor = '[xxx]',
    this.plantName = 'Casa Andrea',
    this.position = 'Via Verdi, 165 - Roma - Italy',
    this.email = 'mariorossi00@mail.com',
    this.version = '0.0',
  });

  final String localUrl;
  final String remoteUrl;
  final String consumptionSensor;
  final String productionSensor;
  final String plantName;
  final String position;
  final String email;
  final String version;

  AccountsState copyWith({
    String? localUrl,
    String? remoteUrl,
    String? consumptionSensor,
    String? productionSensor,
    String? plantName,
    String? position,
    String? email,
    String? version,
  }) {
    return AccountsState(
      localUrl: localUrl ?? this.localUrl,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      consumptionSensor: consumptionSensor ?? this.consumptionSensor,
      productionSensor: productionSensor ?? this.productionSensor,
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
        plantName,
        position,
        email,
        version,
      ];
}

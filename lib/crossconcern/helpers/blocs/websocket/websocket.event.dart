part of 'websocket.bloc.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends WebSocketEvent {}

class FetchConfig extends WebSocketEvent {
  const FetchConfig({required this.onConfigurationFetched});

  final void Function(ConfigurationDto) onConfigurationFetched;

  @override
  List<Object> get props => [onConfigurationFetched];
}

class FetchEntites extends WebSocketEvent {
  const FetchEntites({required this.onEntitiesFetched});

  final void Function(List<Entity>) onEntitiesFetched;

  @override
  List<Object> get props => [onEntitiesFetched];
}
part of 'websocket.bloc.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends WebSocketEvent {
  const ConnectWebSocket({required this.onWebSocketConnected, this.baseUrl = '', this.fallback = ''});

  final void Function() onWebSocketConnected;
  final String baseUrl;
  final String fallback;

  @override
  List<Object> get props => [onWebSocketConnected, baseUrl, fallback];
}

class FetchConfig extends WebSocketEvent {
  const FetchConfig({required this.onConfigurationFetched});

  final void Function(ConfigurationDto) onConfigurationFetched;

  @override
  List<Object> get props => [onConfigurationFetched];
}

class FetchDevice extends WebSocketEvent {
  const FetchDevice({required this.onDevicesFetched});

  final void Function(List<Device>) onDevicesFetched;

  @override
  List<Object> get props => [onDevicesFetched];
}
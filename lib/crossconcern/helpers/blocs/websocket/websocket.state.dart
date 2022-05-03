part of 'websocket.bloc.dart';

class WebSocketState extends Equatable {
  const WebSocketState({
    this.status = HomeAssistantWebSocketStatus.disconnected,
  });

  final HomeAssistantWebSocketStatus status;

  WebSocketState copyWith(
    HomeAssistantWebSocketStatus? status,
  ) {
    return WebSocketState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}

enum HomeAssistantWebSocketStatus { disconnected, connected, retry, error }

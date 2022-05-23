part of 'home_assistant_scan.bloc.dart';

abstract class HomeAssistantEvent extends Equatable {
  const HomeAssistantEvent();

  @override
  List<Object> get props => [];
}

class ScanPressed extends HomeAssistantEvent {
  const ScanPressed({this.timeout = const Duration(seconds: 3)});

  final Duration timeout;

  @override
  List<Object> get props => [timeout];
}

class ManualUrlPressed extends HomeAssistantEvent {}

class UrlSelected extends HomeAssistantEvent {
  const UrlSelected({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class ManualUrlChanged extends HomeAssistantEvent {
  const ManualUrlChanged({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class ManualUrlUnfocused extends HomeAssistantEvent {}

class ManualToggleRemote extends HomeAssistantEvent {}

class UrlSubmitted extends HomeAssistantEvent {
  const UrlSubmitted({required this.onSubmit});

  final void Function(String localUrl, String remoteUrl) onSubmit;

  @override
  List<Object> get props => [onSubmit];
}

class HostFound extends HomeAssistantEvent {
  const HostFound({required this.host});

  final String host;

  @override
  List<Object> get props => [host];
}

class ScanFailed extends HomeAssistantEvent {
  const ScanFailed({required this.error});

  final Error error;

  @override
  List<Object> get props => [error];
}

class ScanCompleted extends HomeAssistantEvent {}

class AuthenticationFailure extends HomeAssistantEvent {}
class AuthenticationSuccess extends HomeAssistantEvent {}
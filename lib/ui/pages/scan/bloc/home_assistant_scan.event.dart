part of 'home_assistant_scan.bloc.dart';

abstract class HomeAssistantEvent extends Equatable {
  const HomeAssistantEvent();

  @override
  List<Object> get props => [];
}

class ScanPressed extends HomeAssistantEvent {}

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

class UrlSubmitted extends HomeAssistantEvent {}

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

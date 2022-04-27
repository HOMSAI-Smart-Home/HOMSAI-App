part of 'url_update.bloc.dart';

abstract class UrlUpdateEvent extends Equatable {
  const UrlUpdateEvent();

  @override
  List<Object> get props => [];
}

class AutoComplete extends UrlUpdateEvent {}

class LocalUrlChanged extends UrlUpdateEvent {
  const LocalUrlChanged({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class RemoteUrlChanged extends UrlUpdateEvent {
  const RemoteUrlChanged({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class UrlSubmitted extends UrlUpdateEvent {
  const UrlSubmitted({required this.onSubmit});

  final Function onSubmit;

  @override
  List<Object> get props => [onSubmit];
}

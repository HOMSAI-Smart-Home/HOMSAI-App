part of 'double_url.bloc.dart';

abstract class DoubleUrlEvent extends Equatable {
  const DoubleUrlEvent();

  @override
  List<Object> get props => [];
}

class DoubleUrlAutoComplete extends DoubleUrlEvent {
  const DoubleUrlAutoComplete({required this.localUrl, required this.remoteUrl});

  final String localUrl;
  final String remoteUrl;

  @override
  List<Object> get props => [localUrl, remoteUrl];
}

class DoubleUrlLocalUrlChanged extends DoubleUrlEvent {
  const DoubleUrlLocalUrlChanged({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class DoubleUrlRemoteUrlChanged extends DoubleUrlEvent {
  const DoubleUrlRemoteUrlChanged({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class DoubleUrlSubmitted extends DoubleUrlEvent {
  const DoubleUrlSubmitted({required this.onSubmit});

  final void Function(
    String localurl,
    String remote,
  ) onSubmit;

  @override
  List<Object> get props => [onSubmit];
}

class DoubleUrlError extends DoubleUrlEvent {}

class Clear extends DoubleUrlEvent {}
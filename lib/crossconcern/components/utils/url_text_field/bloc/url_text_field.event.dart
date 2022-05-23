part of 'url_text_field.bloc.dart';

abstract class UrlTextFieldEvent extends Equatable {
  const UrlTextFieldEvent();

  @override
  List<Object> get props => [];
}

class UrlAutoComplete extends UrlTextFieldEvent{
  const UrlAutoComplete({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class UrlChanged extends UrlTextFieldEvent {
  const UrlChanged({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}

class UrlUnfocused extends UrlTextFieldEvent {}

class UrlError extends UrlTextFieldEvent {}
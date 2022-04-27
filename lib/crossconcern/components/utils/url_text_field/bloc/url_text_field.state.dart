part of 'url_text_field.bloc.dart';

class UrlTextFieldState extends Equatable {
  const UrlTextFieldState({
    this.url = const Url.pure(),
    this.initialUrl = const Url.pure(),
    this.status = FormzStatus.pure,
  });

  final Url url;
  final Url initialUrl;
  final FormzStatus status;

  UrlTextFieldState copyWith({
    Url? url,
    Url? initialUrl,
    FormzStatus? status,
  }) {
    return UrlTextFieldState(
      url: url ?? this.url,
      initialUrl: initialUrl ?? this.initialUrl,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [url, initialUrl, status];
}

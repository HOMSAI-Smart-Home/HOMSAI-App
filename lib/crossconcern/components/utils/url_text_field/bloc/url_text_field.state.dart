part of 'url_text_field.bloc.dart';

class UrlTextFieldState extends Equatable {
  const UrlTextFieldState({
    this.url = const Url.pure(),
    this.initialUrl = "",
    this.status = FormzStatus.pure,
  });

  final Url url;
  final String initialUrl;
  final FormzStatus status;

  UrlTextFieldState copyWith({
    Url? url,
    String? initialUrl,
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

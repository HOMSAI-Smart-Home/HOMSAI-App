part of 'url_text_field.bloc.dart';

class UrlTextFieldState extends Equatable {
  const UrlTextFieldState({
    this.url = const Url.pure(),
    this.initialUrl = "",
    this.status = UrlTextFieldStatus.empity,
  });

  final Url url;
  final String initialUrl;
  final UrlTextFieldStatus status;

  UrlTextFieldState copyWith({
    Url? url,
    String? initialUrl,
    UrlTextFieldStatus? status,
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

enum UrlTextFieldStatus{
  empity,
  valid,
  invalid,
}

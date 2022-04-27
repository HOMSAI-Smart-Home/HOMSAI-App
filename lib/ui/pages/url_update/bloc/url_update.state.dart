part of 'url_update.bloc.dart';

class UrlUpdateState extends Equatable {
  const UrlUpdateState({
    this.localUrl = const Url.pure(),
    this.remoteUrl = const Url.pure(),
    this.status = FormzStatus.pure,
  });

  final Url localUrl;
  final Url remoteUrl;
  final FormzStatus status;

  UrlUpdateState copyWith({
    Url? localUrl,
    Url? remoteUrl,
    FormzStatus? status,
  }) {
    return UrlUpdateState(
        localUrl: localUrl ?? this.localUrl,
        remoteUrl: remoteUrl ?? this.remoteUrl,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [localUrl, remoteUrl, status];
}
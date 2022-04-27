part of 'url_update.bloc.dart';

class UrlUpdateState extends Equatable {
  const UrlUpdateState({
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;

  UrlUpdateState copyWith({
    FormzStatus? status,
  }) {
    return UrlUpdateState(
      status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
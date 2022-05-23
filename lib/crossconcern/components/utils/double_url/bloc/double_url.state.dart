part of 'double_url.bloc.dart';

class DoubleUrlState extends Equatable {
  const DoubleUrlState({
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;

  DoubleUrlState copyWith({
    FormzStatus? status,
  }) {
    return DoubleUrlState(
      status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
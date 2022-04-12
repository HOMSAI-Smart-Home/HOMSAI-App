part of 'intro_beta.bloc.dart';

class IntroBetaState extends Equatable {
  const IntroBetaState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final FormzStatus status;

  IntroBetaState copyWith({
    Email? email,
    FormzStatus? status,
  }) {
    return IntroBetaState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, status];
}

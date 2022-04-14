part of 'intro_beta.bloc.dart';

class IntroBetaState extends Equatable {
  const IntroBetaState({
    this.email = const Email.pure(),
    this.initialEmail = "",
    this.status = FormzStatus.pure,
  });

  final Email email;
  final String initialEmail;
  final FormzStatus status;

  IntroBetaState copyWith({
    Email? email,
    String? initialEmail,
    FormzStatus? status,
  }) {
    return IntroBetaState(
      email: email ?? this.email,
      initialEmail: initialEmail ?? this.initialEmail,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, initialEmail, status];
}

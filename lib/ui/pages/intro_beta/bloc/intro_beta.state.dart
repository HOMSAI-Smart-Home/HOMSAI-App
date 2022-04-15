part of 'intro_beta.bloc.dart';

class IntroBetaState extends Equatable {
  const IntroBetaState({
    this.email = const Email.pure(),
    this.initialEmail = "",
    this.status = FormzStatus.pure,
    this.introBetaStatus = IntroBetaStatus.emailEntry,
  });

  final Email email;
  final String initialEmail;
  final FormzStatus status;
  final IntroBetaStatus introBetaStatus;

  IntroBetaState copyWith({
    Email? email,
    String? initialEmail,
    FormzStatus? status,
    IntroBetaStatus? introBetaStatus,
  }) {
    return IntroBetaState(
      email: email ?? this.email,
      initialEmail: initialEmail ?? this.initialEmail,
      status: status ?? this.status,
      introBetaStatus: introBetaStatus ?? this.introBetaStatus,
    );
  }

  @override
  List<Object> get props => [email, initialEmail, status, introBetaStatus];
}

enum IntroBetaStatus {
  emailEntry,
  loading,
  pending,
  notRegistered,
}
part of 'credentials_form.bloc.dart';

abstract class CredentialsFormEvent extends Equatable {
  const CredentialsFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends CredentialsFormEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class EmailUnfocused extends CredentialsFormEvent {}

class PasswordChanged extends CredentialsFormEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordUnfocused extends CredentialsFormEvent {}

class FormSubmitted extends CredentialsFormEvent {}

class AgreementChanged extends CredentialsFormEvent {
  const AgreementChanged({required this.agreement});

  final bool agreement;

  @override
  List<Object> get props => [agreement];
}

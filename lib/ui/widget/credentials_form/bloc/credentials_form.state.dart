part of 'credentials_form.bloc.dart';

class CredentialsFormState extends Equatable {
  const CredentialsFormState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.agreement,
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final bool? agreement;
  final FormzStatus status;

  CredentialsFormState copyWith({
    Email? email,
    Password? password,
    bool? agreement,
    FormzStatus? status,
  }) {
    return CredentialsFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      agreement: agreement ?? this.agreement,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}

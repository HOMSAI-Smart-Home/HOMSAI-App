import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/helpers/models/forms/email.model.dart';
import 'package:homsai/crossconcern/helpers/models/forms/password.model.dart';

part 'credentials_form.event.dart';
part 'credentials_form.state.dart';

class CredentialsFormBloc
    extends Bloc<CredentialsFormEvent, CredentialsFormState> {
  CredentialsFormBloc() : super(const CredentialsFormState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<EmailUnfocused>(_onEmailUnfocused);
    on<PasswordUnfocused>(_onPasswordUnfocused);
    on<AgreementChanged>(_onAgreementChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  @override
  void onTransition(
      Transition<CredentialsFormEvent, CredentialsFormState> transition) {
    super.onTransition(transition);
  }

  void _onEmailChanged(EmailChanged event, Emitter<CredentialsFormState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email.valid ? email : Email.pure(event.email),
      status: _isFormValidate(email: email),
    ));
  }

  void _onPasswordChanged(
      PasswordChanged event, Emitter<CredentialsFormState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password.valid ? password : Password.pure(event.password),
      status: _isFormValidate(password: password),
    ));
  }

  void _onEmailUnfocused(
      EmailUnfocused event, Emitter<CredentialsFormState> emit) {
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: email,
      status: _isFormValidate(email: email),
    ));
  }

  void _onPasswordUnfocused(
    PasswordUnfocused event,
    Emitter<CredentialsFormState> emit,
  ) {
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      password: password,
      status: _isFormValidate(password: password),
    ));
  }

  void _onAgreementChanged(
      AgreementChanged event, Emitter<CredentialsFormState> emit) {
    emit(state.copyWith(
        agreement: event.agreement,
        status: _isFormValidate(agreement: event.agreement)));
  }

  FormzStatus _isFormValidate(
      {Email? email, Password? password, bool? agreement}) {
    return (agreement ?? state.agreement ?? true)
        ? Formz.validate([email ?? state.email, password ?? state.password])
        : FormzStatus.invalid;
  }

  void _onFormSubmitted(
      FormSubmitted event, Emitter<CredentialsFormState> emit) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(state.copyWith(
      email: email,
      password: password,
      status: Formz.validate([email, password]),
    ));
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    }
  }
}

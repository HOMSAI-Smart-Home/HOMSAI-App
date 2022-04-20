import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/crossconcern/helpers/models/forms/credentials/email.model.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/models/database/user.entity.dart';
import 'package:homsai/main.dart';

part 'intro_beta.event.dart';
part 'intro_beta.state.dart';

class IntroBetaBloc extends Bloc<IntroBetaEvent, IntroBetaState> {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  final AIServiceInterface aiServiceInterface = getIt.get<AIServiceInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  IntroBetaBloc() : super(const IntroBetaState()) {
    on<EmailChanged>(_onEmailChanged);
    on<EmaiAutocomplete>(_onEmailAutocomplete);
    on<OnSubmit>(_onSubmit);
    on<OnSubmitPending>(_onSubmitPending);
    on<OnSubmitError>(_onSubmitError);
    add(EmaiAutocomplete());
  }

  @override
  void onTransition(Transition<IntroBetaEvent, IntroBetaState> transition) {
    super.onTransition(transition);
  }

  void _onEmailChanged(EmailChanged event, Emitter<IntroBetaState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email.valid ? email : Email.pure(event.email),
      status: _isFormValidate(email: email),
    ));
  }

  Future<void> _onEmailAutocomplete(
      EmaiAutocomplete event, Emitter<IntroBetaState> emit) async {
    final userId = appPreferencesInterface.getUserId();

    if (userId != null) {
      final user = await appDatabase.userDao.findUserById(userId);

      if (user != null) {
        final email = Email.dirty(user.email);
        emit(state.copyWith(
          email: email.valid ? email : Email.pure(user.email),
          initialEmail: user.email,
          status: _isFormValidate(email: email),
        ));
      }
    }
  }

  void _onSubmit(OnSubmit event, Emitter<IntroBetaState> emit) async {
    emit(state.copyWith(
      introBetaStatus: IntroBetaStatus.loading,
    ));
    final email = state.email;

    LoginBodyDto loginBodyDto = LoginBodyDto(email.value);
    AiServiceAuth? aiServiceAuth;
    try {
      aiServiceAuth = await aiServiceInterface.getToken(loginBodyDto);
    } catch (e) {
      emit(state.copyWith(
        introBetaStatus: IntroBetaStatus.notRegistered,
      ));
      return;
    }

    if (aiServiceAuth == null) {
      emit(state.copyWith(
        introBetaStatus: IntroBetaStatus.pending,
      ));
      return;
    }

    appPreferencesInterface.setAiServicetToken(aiServiceAuth);

    User? user = await appDatabase.userDao.findUserByEmail(email.value);
    if (user == null) {
      user = User(email.value);
      user.id = await appDatabase.userDao.insertItem(User(email.value));
    }
    appPreferencesInterface.setUserId(user.id!);

    event.onSubmit();
  }

  void _onSubmitPending(OnSubmitPending event, Emitter<IntroBetaState> emit) {
    emit(state.copyWith(
      introBetaStatus: IntroBetaStatus.emailEntry,
      initialEmail: state.email.value,
    ));
  }

  Future _onSubmitError(
      OnSubmitError event, Emitter<IntroBetaState> emit) async {
    emit(state.copyWith(
      introBetaStatus: IntroBetaStatus.loading,
    ));

    await aiServiceInterface.subscribeToBeta(LoginBodyDto(state.email.value));

    emit(state.copyWith(
      introBetaStatus: IntroBetaStatus.pending,
    ));
  }

  FormzStatus _isFormValidate({
    Email? email,
  }) {
    return Formz.validate([
      email ?? state.email,
    ]);
  }
}

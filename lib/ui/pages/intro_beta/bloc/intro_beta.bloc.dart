import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/helpers/models/forms/credentials/email.model.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/user.entity.dart';
import 'package:homsai/main.dart';

part 'intro_beta.event.dart';
part 'intro_beta.state.dart';

class IntroBetaBloc extends Bloc<IntroBetaEvent, IntroBetaState> {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  IntroBetaBloc() : super(const IntroBetaState()) {
    on<EmailChanged>(_onEmailChanged);
    on<EmaiAutocomplete>(_onEmailAutocomplete);
    on<OnSubmit>(_onSubmit);

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
      print("userFind: ${user?.id}:${user?.email}");

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
    final email = state.email;

    User? user = await appDatabase.userDao.findUserByEmail(email.value);
    if (user == null) {
      user = User(email.value);
      user.id = await appDatabase.userDao.insertItem(User(email.value));
    }
    appPreferencesInterface.setUserId(user.id!);

    event.onSubmit();
  }

  FormzStatus _isFormValidate({
    Email? email,
  }) {
    return Formz.validate([
      email ?? state.email,
    ]);
  }
}

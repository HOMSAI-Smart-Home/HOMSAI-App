import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/helpers/models/forms/credentials/email.model.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/main.dart';

part 'intro_beta.event.dart';
part 'intro_beta.state.dart';

class IntroBetaBloc extends Bloc<IntroBetaEvent, IntroBetaState> {

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  IntroBetaBloc() : super(const IntroBetaState()) {
    on<EmailChanged>(_onEmailChanged);
    on<EmailUnfocused>(_onEmailUnfocused);
    on<OnSubmit>(_onSubmit);
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

  void _onEmailUnfocused(EmailUnfocused event, Emitter<IntroBetaState> emit) {
    final email = Email.dirty(state.email.value);
    emit(state.copyWith(
      email: email,
      status: _isFormValidate(email: email),
    ));
  }

  void _onSubmit(OnSubmit event, Emitter<IntroBetaState> emit) async {
    //HomeAssistantAuth? auth = appPreferencesInterface.getToken();
    final email = state.email;
    print(email.value);

    //final plantId = await appDatabase.plantDao.insertItem(Plant(
    //  email.value
    //));
    //await appDatabase.plantDao.setActive(plantId);
    //if (state.entities.isNotEmpty) {
    //  await appDatabase.homeAssitantDao.insertEntities(
    //    plantId,
    //    state.entities,
    //  );
    //}
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

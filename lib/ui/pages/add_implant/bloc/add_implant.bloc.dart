import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/main.dart';

part 'add_implant.event.dart';
part 'add_implant.state.dart';

class AddImplantBloc extends Bloc<AddImplantEvent, AddImplantState> {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  AddImplantBloc() : super(const AddImplantState()) {
    on<RetrieveToken>(_onRetrieveToken);
  }

  @override
  void onTransition(Transition<AddImplantEvent, AddImplantState> transition) {
    super.onTransition(transition);
  }

  void _onRetrieveToken(RetrieveToken event, Emitter<AddImplantState> emit) {
    String? token = appPreferencesInterface.getAccessToken();
    emit(state.copyWith(
      token: token,
    ));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/main.dart';

part 'url_update.event.dart';
part 'url_update.state.dart';

class UrlUpdateBloc extends Bloc<UrlUpdateEvent, UrlUpdateState> {
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  LocalUrlTextFieldBloc localUrlTextFieldBloc;
  RemoteUrlTextFieldBloc remoteUrlTextFieldBloc;
  Plant? plant;

  UrlUpdateBloc(
    this.localUrlTextFieldBloc,
    this.remoteUrlTextFieldBloc,
  ) : super(const UrlUpdateState()) {
    on<AutoComplete>(_onAutoColplete);
    on<LocalUrlChanged>(_onLocalUrlChanged);
    on<RemoteUrlChanged>(_onRemoteUrlChange);
    on<UrlSubmitted>(_onUrlSubmitted);

    add(AutoComplete());
  }

  void _onAutoColplete(
    AutoComplete event,
    Emitter<UrlUpdateState> emit,
  ) async {
    plant = await appDatabase.getPlant();

    if (plant != null) {
      localUrlTextFieldBloc.add(UrlAutoComplete(url: plant!.localUrl ?? ''));
      remoteUrlTextFieldBloc.add(UrlAutoComplete(url: plant!.remoteUrl ?? ''));

      emit(
        state.copyWith(status: _isFormValidate()),
      );
    }
  }

  void _onLocalUrlChanged(
    LocalUrlChanged event,
    Emitter<UrlUpdateState> emit,
  ) {
    emit(state.copyWith(status: _isFormValidate()));
  }

  void _onRemoteUrlChange(
    RemoteUrlChanged event,
    Emitter<UrlUpdateState> emit,
  ) {
    emit(state.copyWith(status: _isFormValidate()));
  }

  void _onUrlSubmitted(UrlSubmitted event, Emitter<UrlUpdateState> emit) async {
    plant = plant?.copyWith(
      localUrl: localUrlTextFieldBloc.state.url.value,
      remoteUrl: remoteUrlTextFieldBloc.state.url.value,
    );

    if (plant != null) await appDatabase.plantDao.updateItem(plant!);

    event.onSubmit();
  }

  FormzStatus _isFormValidate() {
    if (localUrlTextFieldBloc.state.status != UrlTextFieldStatus.invalid &&
        remoteUrlTextFieldBloc.state.status != UrlTextFieldStatus.invalid &&
        (localUrlTextFieldBloc.state.status != UrlTextFieldStatus.empity ||
            remoteUrlTextFieldBloc.state.status != UrlTextFieldStatus.empity)) {
      return FormzStatus.valid;
    }

    return FormzStatus.invalid;
  }
}

class LocalUrlTextFieldBloc extends UrlTextFieldBloc {}

class RemoteUrlTextFieldBloc extends UrlTextFieldBloc {}

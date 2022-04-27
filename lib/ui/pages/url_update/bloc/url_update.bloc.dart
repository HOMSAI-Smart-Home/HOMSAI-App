import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';
import 'package:homsai/crossconcern/helpers/models/forms/url.model.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/main.dart';

part 'url_update.event.dart';
part 'url_update.state.dart';

class UrlUpdateBloc extends Bloc<UrlUpdateEvent, UrlUpdateState> {
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  LocalUrlTextFieldBlock localUrlTextFieldBlock;
  RemoteUrlTextFieldBlock remoteUrlTextFieldBlock;

  UrlUpdateBloc(
    this.localUrlTextFieldBlock,
    this.remoteUrlTextFieldBlock,
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
    final plant = await appDatabase.plantDao.getActivePlant();
    print('plant: ${plant?.consumptionSensor}');
    print('plant: ${plant?.productionSensor}');
    print('plant: ${plant?.localUrl}');
    print('plant: ${plant?.remoteUrl}');
    print('plant: ${plant?.name}');
    print('plant: ${plant?.longitude}:${plant?.latitude}');

    if (plant != null) {
      localUrlTextFieldBlock.add(UrlAutoComplete(url: plant.localUrl));
      remoteUrlTextFieldBlock.add(UrlAutoComplete(url: plant.remoteUrl));

      final localUrl = Url.dirty(plant.localUrl);
      final remoteUrl = Url.dirty(plant.remoteUrl);

      emit(state.copyWith(
        localUrl: localUrl.valid ? localUrl : Url.pure(plant.localUrl),
        remoteUrl: remoteUrl.valid ? remoteUrl : Url.pure(plant.remoteUrl),
        status: _isFormValidate(localUrl: localUrl, remoteUrl: remoteUrl),
      ));
    }
  }

  void _onLocalUrlChanged(
    LocalUrlChanged event,
    Emitter<UrlUpdateState> emit,
  ) {
    localUrlTextFieldBlock.add(UrlChanged(url: event.url));

    final url = Url.dirty(event.url);
    emit(state.copyWith(
      localUrl: url.valid ? url : Url.pure(event.url),
    ));
  }

  void _onRemoteUrlChange(
    RemoteUrlChanged event,
    Emitter<UrlUpdateState> emit,
  ) {
    remoteUrlTextFieldBlock.add(UrlChanged(url: event.url));

    final url = Url.dirty(event.url);
    emit(state.copyWith(
      localUrl: url.valid ? url : Url.pure(event.url),
    ));
  }

  void _onUrlSubmitted(UrlSubmitted event, Emitter<UrlUpdateState> emit) async {
    final localUrl = Url.dirty(state.localUrl.value);
    final remoteUrl = Url.dirty(state.remoteUrl.value);

    if (_isFormValidate(localUrl: localUrl, remoteUrl: remoteUrl).isInvalid) {
      emit(state.copyWith(
        status: _isFormValidate(localUrl: localUrl, remoteUrl: remoteUrl)
      ));
      return;
    }

    event.onSubmit();
  }

  FormzStatus _isFormValidate({Url? localUrl, Url? remoteUrl}) {
    return Formz.validate([
      localUrl ?? state.localUrl,
      remoteUrl ?? state.remoteUrl,
    ]);
  }
}

class LocalUrlTextFieldBlock extends UrlTextFieldBloc {}

class RemoteUrlTextFieldBlock extends UrlTextFieldBloc {}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/ui/widget/utils/url_text_field/bloc/url_text_field.bloc.dart';

part 'double_url.event.dart';
part 'double_url.state.dart';

class DoubleUrlBloc extends Bloc<DoubleUrlEvent, DoubleUrlState> {
  LocalUrlTextFieldBloc? localUrlTextFieldBloc;
  RemoteUrlTextFieldBloc? remoteUrlTextFieldBloc;

  DoubleUrlBloc() : super(const DoubleUrlState()) {
    on<DoubleUrlAutoComplete>(_onAutoColplete);
    on<DoubleUrlLocalUrlChanged>(_onLocalUrlChanged);
    on<DoubleUrlRemoteUrlChanged>(_onRemoteUrlChange);
    on<DoubleUrlSubmitted>(_onUrlSubmitted);
    on<DoubleUrlError>(_onUrlError);
    on<Clear>(_onClear);
  }

  void initializeBlocs({
    LocalUrlTextFieldBloc? localUrlTextFieldBloc,
    RemoteUrlTextFieldBloc? remoteUrlTextFieldBloc,
  }) {
    if (localUrlTextFieldBloc != null) {
      this.localUrlTextFieldBloc = localUrlTextFieldBloc;
    }
    if (remoteUrlTextFieldBloc != null) {
      this.remoteUrlTextFieldBloc = remoteUrlTextFieldBloc;
    }
  }

  void _onAutoColplete(
    DoubleUrlAutoComplete event,
    Emitter<DoubleUrlState> emit,
  ) {
    localUrlTextFieldBloc?.add(UrlAutoComplete(url: event.localUrl));
    remoteUrlTextFieldBloc?.add(UrlAutoComplete(url: event.remoteUrl));

    emit(
      state.copyWith(status: _isFormValidate()),
    );
  }

  void _onLocalUrlChanged(
    DoubleUrlLocalUrlChanged event,
    Emitter<DoubleUrlState> emit,
  ) {
    emit(state.copyWith(status: _isFormValidate()));
  }

  void _onRemoteUrlChange(
    DoubleUrlRemoteUrlChanged event,
    Emitter<DoubleUrlState> emit,
  ) {
    emit(state.copyWith(status: _isFormValidate()));
  }

  void _onUrlSubmitted(
    DoubleUrlSubmitted event,
    Emitter<DoubleUrlState> emit,
  ) {
    event.onSubmit(
      localUrlTextFieldBloc?.state.url.value ?? '',
      remoteUrlTextFieldBloc?.state.url.value ?? '',
    );
  }

  void _onUrlError(
    DoubleUrlError event,
    Emitter<DoubleUrlState> emit,
  ) {
    localUrlTextFieldBloc?.add(UrlError());
    remoteUrlTextFieldBloc?.add(UrlError());
  }

  void _onClear(
    Clear event,
    Emitter<DoubleUrlState> emit,
  ) {
    localUrlTextFieldBloc?.add(const UrlChanged(url: ''));
    remoteUrlTextFieldBloc?.add(const UrlChanged(url: ''));

    emit(state.copyWith(status: FormzStatus.invalid));
  }

  FormzStatus _isFormValidate() {
    if (localUrlTextFieldBloc == null || remoteUrlTextFieldBloc == null) {
      return FormzStatus.invalid;
    }

    if (localUrlTextFieldBloc!.state.status != UrlTextFieldStatus.invalid &&
        remoteUrlTextFieldBloc!.state.status != UrlTextFieldStatus.invalid &&
        (localUrlTextFieldBloc!.state.status != UrlTextFieldStatus.empity ||
            remoteUrlTextFieldBloc!.state.status !=
                UrlTextFieldStatus.empity)) {
      return FormzStatus.valid;
    }

    return FormzStatus.invalid;
  }
}

class LocalUrlTextFieldBloc extends UrlTextFieldBloc {}

class RemoteUrlTextFieldBloc extends UrlTextFieldBloc {}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/helpers/models/forms/url.model.dart';

part 'url_text_field.event.dart';
part 'url_text_field.state.dart';

class UrlTextFieldBloc extends Bloc<UrlTextFieldEvent, UrlTextFieldState> {
  UrlTextFieldBloc() : super(const UrlTextFieldState()) {
    on<UrlAutoComplete>(_onUrlAutocomplete);
    on<UrlChanged>(_onUrlChanged);
    on<UrlUnfocused>(_onUrlUnfocused);
    on<UrlError>(_onError);
  }

  void _onUrlAutocomplete(
      UrlAutoComplete event, Emitter<UrlTextFieldState> emit) {
    final urlTrimmed = event.url.trim();
    final url = Url.dirty(urlTrimmed);
    emit(state.copyWith(
      initialUrl: urlTrimmed,
      url: url.valid ? url : Url.pure(urlTrimmed),
      status: _isUrlValid(url),
    ));
  }

  void _onUrlChanged(UrlChanged event, Emitter<UrlTextFieldState> emit) {
    final urlTrimmed = event.url.trim();
    final urlDirty = Url.dirty(urlTrimmed);
    emit(state.copyWith(
      url: urlDirty.valid ? urlDirty : Url.pure(urlTrimmed),
      status: _isUrlValid(urlDirty),
    ));
  }

  void _onUrlUnfocused(UrlUnfocused event, Emitter<UrlTextFieldState> emit) {
    emit(state.copyWith(
      status: _isUrlValid(state.url),
    ));
  }

  void _onError(UrlError event, Emitter<UrlTextFieldState> emit) {
    if (state.url.value.isNotEmpty){
      emit(state.copyWith(
        status: UrlTextFieldStatus.invalid,
      ));
    }
  }

  UrlTextFieldStatus _isUrlValid(Url url) {
    if (url.value == "") return UrlTextFieldStatus.empity;
    return Formz.validate([url]) == FormzStatus.valid
        ? UrlTextFieldStatus.valid
        : UrlTextFieldStatus.invalid;
  }
}

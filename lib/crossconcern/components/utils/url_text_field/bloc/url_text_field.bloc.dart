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
  }

  void _onUrlAutocomplete(
      UrlAutoComplete event, Emitter<UrlTextFieldState> emit) {
    final url = Url.dirty(event.url);
    emit(state.copyWith(
      initialUrl: event.url,
      url: url.valid ? url : Url.pure(event.url),
      status: _isUrlValid(url: url),
    ));
  }

  void _onUrlChanged(UrlChanged event, Emitter<UrlTextFieldState> emit) {
    final urlDirty = Url.dirty(event.url);
    emit(state.copyWith(
      url: urlDirty.valid ? urlDirty : Url.pure(event.url),
      status: _isUrlValid(url: urlDirty),
    ));
  }

  void _onUrlUnfocused(UrlUnfocused event, Emitter<UrlTextFieldState> emit) {
    emit(state.copyWith(
      status: _isUrlValid(url: state.url),
    ));
  }

  FormzStatus _isUrlValid({
    Url? url,
  }) {
    if (url?.value == "") return FormzStatus.valid;
    return Formz.validate([url ?? state.url]);
  }
}

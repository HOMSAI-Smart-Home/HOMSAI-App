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
    print("yoo: ${event.url}");

    final url = Url.dirty(event.url);
    emit(state.copyWith(
      initialUrl: url.valid ? url : Url.pure(event.url),
      url: url.valid ? url : Url.pure(event.url)
    ));
  }

  void _onUrlChanged(UrlChanged event, Emitter<UrlTextFieldState> emit) {
    final url = Url.dirty(event.url);
    emit(state.copyWith(
      url: url.valid ? url : Url.pure(event.url),
      status: _isFormValidate(url: url),
    ));
  }

  void _onUrlUnfocused(UrlUnfocused event, Emitter<UrlTextFieldState> emit) {
    final url = Url.dirty(state.url.value);
    emit(state.copyWith(
      url: url,
      status: _isFormValidate(url: url),
    ));
  }

  FormzStatus _isFormValidate({
    Url? url,
  }) {
    return Formz.validate([url ?? state.url]);
  }
}

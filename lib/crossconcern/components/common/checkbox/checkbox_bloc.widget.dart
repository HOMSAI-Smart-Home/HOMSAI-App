import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_event.widget.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_state.widget.dart';

class CheckboxBloc extends Bloc<CheckboxEvent, CheckboxState> {
  bool initialValue;
  CheckboxBloc(this.initialValue) : super(const CheckboxState()) {
    on<Toggle>(_onToggle);
  }

  void _onToggle(Toggle event, Emitter<CheckboxState> emit) {
    emit(state.copyWith(
      remote: !state.remote,
    ));
  }
}

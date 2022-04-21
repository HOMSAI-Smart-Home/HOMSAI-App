import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckboxBloc extends Bloc<CheckboxEvent, CheckboxScanState>{
  CheckboxBloc(initialState) : super(initialState){
    on<Toggle>(_onToggle);
  }

  void _onToggle(Toggle event, Emitter<CheckboxScanState> emit){
    emit(state.copyWith(
      remote: !state.remote,
    ));
  }
}

class CheckboxScanState {
  const CheckboxScanState({
    required this.remote,
  });

  final bool remote;

  CheckboxScanState copyWith({
    bool? remote,
  }) {
    return CheckboxScanState(
      remote: remote ?? this.remote,
      
    );
  }

  @override
  List<Object> get props => [remote];
}

class CheckboxEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Toggle extends CheckboxEvent {}
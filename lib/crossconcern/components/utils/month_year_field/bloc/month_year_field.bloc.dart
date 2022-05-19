import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
part 'month_year_field.event.dart';
part 'month_year_field.state.dart';

class MonthYearFieldBloc
    extends Bloc<MonthYearFieldEvent, MonthYearFieldState> {
  MonthYearFieldBloc() : super(const MonthYearFieldState()) {
    on<FieldValidate>(_onFieldValidation);
  }

  void _onFieldValidation(
      FieldValidate event, Emitter<MonthYearFieldState> emit) {
    print("VALIDATION BLOC TEXT: ${event.errorText}");
    emit(
      state.copyWith(errorText: event.errorText),
    );
  }
}

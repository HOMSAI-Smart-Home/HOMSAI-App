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
    on<FieldValueChanged>(_onFieldValueChanged);
  }

  void _onFieldValidation(
      FieldValidate event, Emitter<MonthYearFieldState> emit) {
    emit(
      state.copyWith(errorText: event.errorText),
    );
  }

  void _onFieldValueChanged(
      FieldValueChanged event, Emitter<MonthYearFieldState> emit) {
    emit(
      state.copyWith(
          valueChanged: event.valueChanged, selection: event.selection),
    );
  }
}

DateTime? parseMonthYearDate(String dateString) {
  var controlRegex = RegExp(r'^\d{2}\/\d{4}$');
  if (controlRegex.hasMatch(dateString) == false) {
    return null;
  }
  final month = int.parse(dateString.split("/")[0]);
  final year = int.parse(dateString.split("/")[1]);
  return DateTime(year, month);
}

String? parseMonthYearString(DateTime? date) {
  if (date == null) {
    return null;
  }
  final year = date.year.toString();
  final month =
      date.month >= 10 ? date.month.toString() : "0${date.month.toString()}";
  return "$month/$year";
}

bool checkMonthYearDate(String dateString, DateTime dateParsed) {
  // Check if Month/Year date is correct and is not in the future
  final year = int.parse(dateString.split("/")[1]);
  final now = DateTime(DateTime.now().year, DateTime.now().month);
  if (dateParsed.year != year || dateParsed.isAfter(now)) {
    return false;
  }
  return true;
}

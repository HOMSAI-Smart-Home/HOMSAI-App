part of 'month_year_field.bloc.dart';

abstract class MonthYearFieldEvent extends Equatable {
  const MonthYearFieldEvent();

  @override
  List<Object> get props => [];
}

class FieldChanged extends MonthYearFieldEvent {
  const FieldChanged(
      {required this.value,
      required this.controller,
      required this.monthLetter,
      required this.yearLetter});

  final String value;
  final TextEditingValue controller;
  final String monthLetter;
  final String yearLetter;

  @override
  List<Object> get props => [value, controller, monthLetter, yearLetter];
}

class FieldUnfocused extends MonthYearFieldEvent {
  const FieldUnfocused({
    required this.startValue,
  });

  final String startValue;

  @override
  List<Object> get props => [startValue];
}

class FieldFocused extends MonthYearFieldEvent {
  const FieldFocused({
    required this.controllerText,
  });

  final String controllerText;

  @override
  List<Object> get props => [controllerText];
}

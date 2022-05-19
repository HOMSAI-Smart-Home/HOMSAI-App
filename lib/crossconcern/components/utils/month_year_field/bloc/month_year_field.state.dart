part of 'month_year_field.bloc.dart';

class MonthYearFieldState extends Equatable {
  const MonthYearFieldState(
      {this.initialValue = "", this.controller = const TextEditingValue()});

  final String initialValue;
  final TextEditingValue controller;

  MonthYearFieldState copyWith({
    String? initialValue,
    required TextEditingValue controller,
  }) {
    return MonthYearFieldState(
        initialValue: initialValue ?? this.initialValue,
        controller: controller);
  }

  @override
  List<Object> get props => [initialValue, controller];
}

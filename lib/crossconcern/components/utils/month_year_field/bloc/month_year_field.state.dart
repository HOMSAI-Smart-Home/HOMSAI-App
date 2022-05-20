part of 'month_year_field.bloc.dart';

class MonthYearFieldState extends Equatable {
  const MonthYearFieldState({
    this.errorText = "",
    this.valueChanged = "",
    this.selection = const TextSelection.collapsed(offset: 0),
  });

  final String errorText;
  final String valueChanged;
  final TextSelection selection;

  MonthYearFieldState copyWith({
    String? errorText,
    String? valueChanged,
    TextSelection? selection,
  }) {
    return MonthYearFieldState(
      errorText: errorText ?? this.errorText,
      valueChanged: valueChanged ?? this.valueChanged,
      selection: selection ?? this.selection,
    );
  }

  @override
  List<Object> get props => [
        errorText,
        valueChanged,
        selection,
      ];
}

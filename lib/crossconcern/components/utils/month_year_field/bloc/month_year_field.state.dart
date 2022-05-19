part of 'month_year_field.bloc.dart';

class MonthYearFieldState extends Equatable {
  const MonthYearFieldState(
      {
    this.errorText = "",
  });

  final String errorText;

  MonthYearFieldState copyWith({
    String? errorText,
  }) {
    return MonthYearFieldState(
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object> get props => [errorText];
}

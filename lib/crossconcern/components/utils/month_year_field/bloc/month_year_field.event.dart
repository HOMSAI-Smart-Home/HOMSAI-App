part of 'month_year_field.bloc.dart';

abstract class MonthYearFieldEvent extends Equatable {
  const MonthYearFieldEvent();

  @override
  List<Object> get props => [];
}

class FieldValidate extends MonthYearFieldEvent {
  const FieldValidate({
    required this.errorText,
  });

  final String errorText;

  @override
  List<Object> get props => [errorText];
}

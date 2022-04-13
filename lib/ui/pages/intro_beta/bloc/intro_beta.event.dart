part of 'intro_beta.bloc.dart';

abstract class IntroBetaEvent extends Equatable {
  const IntroBetaEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends IntroBetaEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class EmailUnfocused extends IntroBetaEvent {}

class EmaiAutocomplete extends IntroBetaEvent {}

class OnSubmit extends IntroBetaEvent {
  const OnSubmit(this.onSubmit);

  final void Function() onSubmit;

  @override
  List<Object> get props => [onSubmit];
}

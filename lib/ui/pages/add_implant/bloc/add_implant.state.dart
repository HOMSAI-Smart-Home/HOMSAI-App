part of 'add_implant.bloc.dart';

class AddImplantState extends Equatable {
  const AddImplantState({
    this.token,
  });

  final String? token;

  AddImplantState copyWith({
    String? token,
  }) {
    return AddImplantState(token: token ?? this.token);
  }

  @override
  List<Object> get props => [token ?? ""];
}

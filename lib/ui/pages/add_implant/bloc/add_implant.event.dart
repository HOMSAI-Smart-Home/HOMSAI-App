part of 'add_implant.bloc.dart';

abstract class AddImplantEvent extends Equatable {
  const AddImplantEvent();

  @override
  List<Object> get props => [];
}

class RetrieveToken extends AddImplantEvent {}

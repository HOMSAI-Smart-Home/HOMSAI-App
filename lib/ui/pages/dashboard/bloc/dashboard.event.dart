part of 'dashboard.bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class RetrievePlantName extends DashboardEvent {}

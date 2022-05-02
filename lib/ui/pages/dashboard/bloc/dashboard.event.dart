part of 'dashboard.bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class RetrievePlantName extends DashboardEvent {}

class Logout extends DashboardEvent {
  const Logout(this.onLogout);

  final void Function() onLogout;

  @override
  List<Object> get props => [onLogout];
}

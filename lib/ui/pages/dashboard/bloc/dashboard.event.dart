part of 'dashboard.bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class RetrievePlantName extends DashboardEvent {}

class Logout extends DashboardEvent {
  final bool deleteUser;

  const Logout(this.onLogout, {this.deleteUser=true});

  final void Function() onLogout;

  @override
  List<Object> get props => [onLogout];
}

part of 'dashboard.bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.plantName = "",
  });

  final String plantName;

  DashboardState copyWith({
    String? plantName,
  }) {
    return DashboardState(plantName: plantName ?? this.plantName);
  }

  @override
  List<Object> get props => [plantName];
}

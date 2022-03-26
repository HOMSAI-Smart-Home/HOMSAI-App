import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/main.dart';

part 'dashboard.event.dart';
part 'dashboard.state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  DashboardBloc() : super(const DashboardState());

  @override
  void onTransition(Transition<DashboardEvent, DashboardState> transition) {
    super.onTransition(transition);
  }
}

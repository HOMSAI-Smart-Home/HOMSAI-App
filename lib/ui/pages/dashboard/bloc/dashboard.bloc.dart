import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/main.dart';

part 'dashboard.event.dart';
part 'dashboard.state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  DashboardBloc() : super(const DashboardState()) {
    on<RetrievePlantName>(_onRetrievePlantName);
    add(RetrievePlantName());
  }

  @override
  void onTransition(Transition<DashboardEvent, DashboardState> transition) {
    super.onTransition(transition);
  }

  void _onRetrievePlantName(
      RetrievePlantName event, Emitter<DashboardState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    emit(state.copyWith(plantName: plant?.name));
  }
}

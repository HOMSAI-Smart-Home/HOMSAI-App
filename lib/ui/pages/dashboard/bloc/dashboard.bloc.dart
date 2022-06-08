import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/exceptions/token.exception.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/main.dart';

part 'dashboard.event.dart';
part 'dashboard.state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final HomsaiDatabase _appDatabase = getIt.get<HomsaiDatabase>();
  final HomeAssistantInterface _homeAssistantInterface =
      getIt.get<HomeAssistantInterface>();

  final WebSocketBloc _webSocketBloc;
  Function()? onLogOut;

  DashboardBloc(this._webSocketBloc, {this.onLogOut})
      : super(const DashboardState()) {
    on<RetrievePlantName>(_onRetrievePlantName);
    on<Logout>(_onLogout);
    add(RetrievePlantName());

    _webSocketBloc.subscribeToExeption(
      TokenException,
      () => add(Logout(
        () {},
        deleteUser: false,
      )),
    );
  }

  @override
  void onTransition(Transition<DashboardEvent, DashboardState> transition) {
    super.onTransition(transition);
  }

  void _onRetrievePlantName(
      RetrievePlantName event, Emitter<DashboardState> emit) async {
    final plant = await _appDatabase.getPlant();
    emit(state.copyWith(plantName: plant?.name));
  }

  void _onLogout(Logout event, Emitter<DashboardState> emit) async {
    _webSocketBloc.add(WebSocketLogOut(
      onLogOut: () async {
        //TODO:fix when websocket factory
        final plant = await _appDatabase.getPlant();
        _homeAssistantInterface.revokeToken(plant: plant!);
        _appDatabase.logout(deleteUser: event.deleteUser);
        event.onLogout();
        if (onLogOut != null) onLogOut!();
      },
    ));
  }

  @override
  Future<void> close() {
    _webSocketBloc.add(const WebSocketLogOut());
    return super.close();
  }
}

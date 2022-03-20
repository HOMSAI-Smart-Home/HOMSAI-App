import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/crossconcern/exceptions/scanning_not_found.exception.dart';
import 'package:homsai/crossconcern/helpers/models/url.model.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/main.dart';

part 'home_assistant_scan.event.dart';
part 'home_assistant_scan.state.dart';

class HomeAssistantScanBloc
    extends Bloc<HomeAssistantEvent, HomeAssistantScanState> {
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  HomeAssistantScanBloc() : super(const HomeAssistantScanState()) {
    on<ScanPressed>(_onScanPressed);
    on<ManualUrlPressed>(_onManualUrlPressed);
    on<ManualUrlChanged>(_onManualUrlChanged);
    on<ManualUrlUnfocused>(_onManualUrlUnfocused);
    on<UrlSelected>(_onUrlSelected);
    on<UrlSubmitted>(_onUrlSubmitted);
  }

  @override
  void onTransition(
      Transition<HomeAssistantEvent, HomeAssistantScanState> transition) {
    super.onTransition(transition);
  }

  void _onScanPressed(
      ScanPressed event, Emitter<HomeAssistantScanState> emit) async {
    emit(state.copyWith(
      selectedUrl: const Url.pure(),
      status: HomeAssistantScanStatus.scanningInProgress,
    ));

    await homeAssistantRepository.startScan().then((possibleHosts) {
      throwIf(possibleHosts.isEmpty, HostsNotFound);

      return emit(state.copyWith(
        scannedUrls: possibleHosts,
        selectedUrl: Url.pure(possibleHosts.first),
        status: HomeAssistantScanStatus.scanningSuccess,
      ));
    }).catchError((error, stackTrace) => emit(
          state.copyWith(status: HomeAssistantScanStatus.scanningFailure),
        ));
  }

  void _onManualUrlPressed(
      ManualUrlPressed event, Emitter<HomeAssistantScanState> emit) {
    emit(state.copyWith(
      status: HomeAssistantScanStatus.manual,
    ));
  }

  void _onManualUrlChanged(
      ManualUrlChanged event, Emitter<HomeAssistantScanState> emit) {
    final url = Url.dirty(event.url);
    emit(state.copyWith(
        selectedUrl: url.valid ? url : Url.pure(event.url),
        status: HomeAssistantScanStatus.manual));
  }

  void _onManualUrlUnfocused(
      ManualUrlUnfocused event, Emitter<HomeAssistantScanState> emit) {
    final url = Url.dirty(state.selectedUrl.value);
    emit(state.copyWith(
      selectedUrl: url,
    ));
  }

  void _onUrlSelected(UrlSelected event, Emitter<HomeAssistantScanState> emit) {
    final url = Url.dirty(event.url);
    emit(state.copyWith(
      selectedUrl: url.valid ? url : Url.pure(event.url),
    ));
  }

  void _onUrlSubmitted(
      UrlSubmitted event, Emitter<HomeAssistantScanState> emit) async {
    emit(state.copyWith(
        status: HomeAssistantScanStatus.authenticationInProgress));

    await homeAssistantRepository
        .authenticate(url: state.selectedUrl.value)
        .then((authResult) {
      appPreferencesInterface.setAccessToken(authResult.token);
      return emit(
        state.copyWith(status: HomeAssistantScanStatus.authenticationSuccess),
      );
    }).catchError((error, stackTrace) => emit(state.copyWith(
            status: HomeAssistantScanStatus.authenticationFailure)));
  }
}

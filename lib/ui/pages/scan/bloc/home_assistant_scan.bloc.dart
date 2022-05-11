import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_bloc.widget.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_event.widget.dart';
import 'package:homsai/crossconcern/helpers/models/forms/url.model.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/globalkeys.widget.dart';
import 'package:homsai/main.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'home_assistant_scan.event.dart';
part 'home_assistant_scan.state.dart';

class HomeAssistantScanBloc
    extends Bloc<HomeAssistantEvent, HomeAssistantScanState> {
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  StreamSubscription<String>? _scanSubscription;
  CheckboxBloc checkboxBloc;

  HomeAssistantScanBloc(this.checkboxBloc)
      : super(const HomeAssistantScanState()) {
    on<ScanPressed>(_onScanPressed, transformer: restartable());
    on<ManualUrlPressed>(_onManualUrlPressed);
    on<ManualUrlChanged>(_onManualUrlChanged);
    on<ManualUrlUnfocused>(_onManualUrlUnfocused);
    on<ManualToggleRemote>(_onManualToggleRemote);
    on<UrlSelected>(_onUrlSelected);
    on<UrlSubmitted>(_onUrlSubmitted);
    on<HostFound>(_onHostFound, transformer: sequential());
    on<ScanFailed>(_onScanFailure);

    add(const ScanPressed());
  }

  @override
  void onTransition(
      Transition<HomeAssistantEvent, HomeAssistantScanState> transition) {
    super.onTransition(transition);
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    return super.close();
  }

  void _onScanPressed(
      ScanPressed event, Emitter<HomeAssistantScanState> emit) async {
    emit(state.copyWith(
      selectedUrl: const Url.pure(),
      scannedUrls: state.scannedUrls.isEmpty ? [] : state.scannedUrls,
      status: state.status != HomeAssistantScanStatus.scanningSuccess
          ? HomeAssistantScanStatus.scanningInProgress
          : state.status,
    ));

    try {
      await _scanSubscription?.cancel();
      _scanSubscription = await homeAssistantRepository.scan(
        onData: (host) => add(HostFound(host: host)),
        timeout: event.timeout,
      );
      _scanSubscription?.onDone(() => add(ScanPressed(
          timeout: Duration(seconds: event.timeout.inSeconds * 2))));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      add(ScanFailed(error: Error()));
    }
  }

  void _onHostFound(HostFound hostFound, Emitter<HomeAssistantScanState> emit) {
    List<String> scannedUrls = state.scannedUrls;
    if (!state.status.isManual) {
      if (scannedUrls.contains(hostFound.host)) return;

      scannedUrls.add(hostFound.host);
      emit(state.copyWith(
          scannedUrls: List.from(scannedUrls),
          status: HomeAssistantScanStatus.scanningSuccess));
      GlobalKeys.scannedUrlsAnimatedList.currentState?.insertItem(
          scannedUrls.length - 1,
          duration: const Duration(milliseconds: 250));
    }
  }

  void _onScanFailure(
      ScanFailed possibleHostFound, Emitter<HomeAssistantScanState> emit) {
    if (!state.status.isManual) {
      emit(state.copyWith(status: HomeAssistantScanStatus.scanningFailure));
    }
  }

  void _onManualUrlPressed(
      ManualUrlPressed event, Emitter<HomeAssistantScanState> emit) {
    _scanSubscription?.cancel();
    _scanSubscription = null;

    emit(state.copyWith(
      selectedUrl: const Url.pure(),
      scannedUrls: const [],
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

  void _onManualToggleRemote(
      ManualToggleRemote event, Emitter<HomeAssistantScanState> emit) {
    checkboxBloc.add(Toggle());
    emit(state.copyWith(
      remoteUrl: !state.remoteUrl,
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
    final url = Url.dirty(state.selectedUrl.value);
    final remote = state.remoteUrl;
    emit(state.copyWith(
      selectedUrl: url,
    ));

    if (state.selectedUrl.invalid) return;

    emit(state.copyWith(
        status: HomeAssistantScanStatus.authenticationInProgress));

    try {
      final authResult = await homeAssistantRepository.authenticate(
        url: Uri.parse(url.value),
        remote: remote,
      );

      appPreferencesInterface.setHomeAssistantToken(authResult);

      emit(
        state.copyWith(
            status: HomeAssistantScanStatus.authenticationSuccess,
            remoteUrl: remote,
            selectedUrl: url),
      );
    } catch (e) {
      emit(state.copyWith(
          status: HomeAssistantScanStatus.authenticationFailure));
    }
  }
}

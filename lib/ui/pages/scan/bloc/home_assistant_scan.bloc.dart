import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/helpers/models/forms/url.model.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/globalkeys.widget.dart';
import 'package:homsai/main.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'home_assistant_scan.event.dart';
part 'home_assistant_scan.state.dart';

class HomeAssistantScanBloc
    extends Bloc<HomeAssistantEvent, HomeAssistantScanState> {
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  StreamSubscription<HostModel>? _scanSubscription;

  HomeAssistantScanBloc() : super(const HomeAssistantScanState()) {
    on<ScanPressed>(_onScanPressed, transformer: restartable());
    on<ManualUrlPressed>(_onManualUrlPressed);
    on<ManualUrlChanged>(_onManualUrlChanged);
    on<ManualUrlUnfocused>(_onManualUrlUnfocused);
    on<UrlSelected>(_onUrlSelected);
    on<UrlSubmitted>(_onUrlSubmitted);
    on<HostFound>(_onHostFound, transformer: sequential());
    on<ScanFailed>(_onScanFailure);
    on<ScanCompleted>(_onScanCompleted);
    on<EnableManualUrlButton>(_onEnableManualUrlButton);
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
      scannedUrls: [],
      enableManualUrlButton: false,
      status: HomeAssistantScanStatus.scanningInProgress,
    ));

    Future.delayed(const Duration(seconds: 5), () {
      add(EnableManualUrlButton());
    });

    _scanSubscription?.cancel();
    List<String> hosts = await homeAssistantRepository.discoverAvailableHosts();
    _scanSubscription = homeAssistantRepository.scan(
        hosts: hosts,
        onData: (host) => add(HostFound(host: host)),
        onError: (error, stackTrace) => add(ScanFailed(error: error)));
    _scanSubscription?.onDone(() {
      if (state.scannedUrls.isEmpty) {
        add(ScanFailed(error: Error()));
      } else {
        add(ScanCompleted());
      }
    });
  }

  void _onHostFound(HostFound hostFound, Emitter<HomeAssistantScanState> emit) {
    List<String> scannedUrls = state.scannedUrls;
    if (!state.status.isManual) {
      scannedUrls.add(hostFound.host);
      emit(state.copyWith(
        scannedUrls: List.from(scannedUrls),
      ));
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

  void _onScanCompleted(
      ScanCompleted scanCompleted, Emitter<HomeAssistantScanState> emit) {
    if (!state.status.isManual) {
      emit(state.copyWith(status: HomeAssistantScanStatus.scanningSuccess));
    }
  }

  void _onEnableManualUrlButton(
      EnableManualUrlButton event, Emitter<HomeAssistantScanState> emit) {
    emit(state.copyWith(
      enableManualUrlButton: true,
    ));
  }

  void _onManualUrlPressed(
      ManualUrlPressed event, Emitter<HomeAssistantScanState> emit) {
    _scanSubscription?.cancel();
    _scanSubscription = null;

    emit(state.copyWith(
      selectedUrl: const Url.pure(),
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
    final url = Url.dirty(state.selectedUrl.value);
    emit(state.copyWith(
      selectedUrl: url,
    ));
    if (state.selectedUrl.invalid) return;

    emit(state.copyWith(
        status: HomeAssistantScanStatus.authenticationInProgress));

    await homeAssistantRepository
        .authenticate(url: Uri.parse(state.selectedUrl.value))
        .then((authResult) {
      appPreferencesInterface.setToken(authResult);

      return emit(
        state.copyWith(status: HomeAssistantScanStatus.authenticationSuccess),
      );
    }).catchError((error, stackTrace) => emit(state.copyWith(
            status: HomeAssistantScanStatus.authenticationFailure)));
  }
}

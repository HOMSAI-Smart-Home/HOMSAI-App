import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/crossconcern/helpers/models/url.model.dart';
import 'package:homsai/main.dart';

part 'home_assistant_scan.event.dart';
part 'home_assistant_scan.state.dart';

class HomeAssistantScanBloc
    extends Bloc<HomeAssistantEvent, HomeAssistantScanState> {
  final HomeAssistantInterface homeAssistantInterface =
      getIt.get<HomeAssistantInterface>();

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
    await Future<void>.delayed(const Duration(seconds: 2));
    emit(state.copyWith(
      scannedUrls: [
        "192.168.0.102:8123",
        "http://192.168.1.2",
        "http://192.168.1.3"
      ],
      selectedUrl: const Url.pure("192.168.0.102:8123"),
      status: HomeAssistantScanStatus.scanningFailure,
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
    ));
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
    await homeAssistantInterface
        .authenticate(url: state.selectedUrl.value)
        .then((authResult) => emit(
              state.copyWith(
                  status: HomeAssistantScanStatus.authenticationSuccess),
            ))
        .catchError((error, stackTrace) => emit(state.copyWith(
            status: HomeAssistantScanStatus.authenticationFailure)));
  }
}

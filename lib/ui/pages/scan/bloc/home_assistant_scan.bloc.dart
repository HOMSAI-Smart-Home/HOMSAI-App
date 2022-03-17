import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/models/url.model.dart';

part 'home_assistant_scan.event.dart';
part 'home_assistant_scan.state.dart';

class HomeAssistantScanBloc
    extends Bloc<HomeAssistantEvent, HomeAssistantScanState> {
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
    await Future<void>.delayed(const Duration(seconds: 10));
    emit(state.copyWith(
      scannedUrls: [
        "http://192.168.1.1",
        "http://192.168.1.2",
        "http://192.168.1.3"
      ],
      selectedUrl: const Url.pure("http://192.168.1.1"),
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
      UrlSubmitted event, Emitter<HomeAssistantScanState> emit) {}
}

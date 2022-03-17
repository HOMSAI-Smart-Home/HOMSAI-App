part of 'home_assistant_scan.bloc.dart';

class HomeAssistantScanState extends Equatable {
  const HomeAssistantScanState(
      {this.scannedUrls = const [],
      this.selectedUrl = const Url.pure(),
      this.status = HomeAssistantScanStatus.scanningInProgress});

  final List<String> scannedUrls;
  final Url selectedUrl;
  final HomeAssistantScanStatus status;

  HomeAssistantScanState copyWith(
      {List<String>? scannedUrls,
      Url? selectedUrl,
      HomeAssistantScanStatus? status}) {
    return HomeAssistantScanState(
        scannedUrls: scannedUrls ?? this.scannedUrls,
        selectedUrl: selectedUrl ?? this.selectedUrl,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [scannedUrls, selectedUrl, status];
}

/// Enum representing the status the [HomeAssistantScanPage] at any given point in time.
enum HomeAssistantScanStatus {
  manual,
  scanningInProgress,
  scanningSuccess,
  scanningFailure,
}

const _urlSubmittableStatus = <HomeAssistantScanStatus>{
  HomeAssistantScanStatus.scanningSuccess,
  HomeAssistantScanStatus.manual,
};

const _scannedCompleteStatus = <HomeAssistantScanStatus>{
  HomeAssistantScanStatus.scanningSuccess,
  HomeAssistantScanStatus.scanningFailure,
};

/// Useful extensions on [HomeAssistantScanStatus]
extension HomeAssistantScanStatusX on HomeAssistantScanStatus {
  bool get isManual => this == HomeAssistantScanStatus.manual;

  bool get isScanningInProgress =>
      this == HomeAssistantScanStatus.scanningInProgress;

  bool get isScanningSuccess => this == HomeAssistantScanStatus.scanningSuccess;

  bool get isScanningFailure => this == HomeAssistantScanStatus.scanningFailure;

  bool get isScanningComplete => _scannedCompleteStatus.contains(this);

  bool get canSubmitUrl => _urlSubmittableStatus.contains(this);
}

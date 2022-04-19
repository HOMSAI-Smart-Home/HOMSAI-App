extension HomeAssistantDateTime on DateTime {
  String get formatHA => toIso8601String();
}

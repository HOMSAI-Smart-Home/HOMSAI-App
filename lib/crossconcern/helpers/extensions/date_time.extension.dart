import 'package:timezone/timezone.dart';

extension HomeAssistantDateTime on TZDateTime {
  String get format {
    String _twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final iso8601 = toIso8601String();
    var offset = timeZone.offset;

    var offSign = offset.sign >= 0 ? '+' : '-';
    offset = offset.abs() ~/ 1000;
    var offH = _twoDigits(offset ~/ 3600);
    var offM = _twoDigits((offset % 3600) ~/ 60);

    return (iso8601.endsWith('Z'))
        ? iso8601
        : iso8601.split(offSign).first + "$offSign$offH:$offM";
  }
}

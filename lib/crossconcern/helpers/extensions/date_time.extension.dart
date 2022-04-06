import 'package:intl/intl.dart';

extension HomeAssistantDateTime on DateTime {
  static String format = 'YYYY-MM-DDThh:mm:ssTZD';

  String get formatHA => DateFormat(format).format(this);
}
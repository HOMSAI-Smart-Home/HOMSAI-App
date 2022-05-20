import 'dart:async';

import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook.dto.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook_body.dto.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class HomeAssistantInterface {
  Future<HomeAssistantAuth> authenticate({
    required Uri baseUrl,
    Uri? fallback,
  });
  Future<StreamSubscription<String>> scan({
    required void Function(String) onData,
    Function? onError,
    Duration? timeout,
  });
  Future<Uri> canConnectToHomeAssistant({
    required Uri baseUrl,
    Uri? fallback,
    Duration timeout = const Duration(seconds: 2),
  });
  Future<HomeAssistantAuth> refreshToken({
    required Uri url,
    Duration timeout,
  });
  Future revokeToken({
    required Plant plant,
    Duration timeout,
  });
  Future<List<HistoryDto>> getHistory(
      {required Plant plant,
      required HistoryBodyDto historyBodyDto,
      Duration timeout,
      required bool isConsumption});
  Future<LogbookDto> getLogBook({
    required Plant plant,
    DateTime? start,
    LogbookBodyDto? logbookBodyDto,
  });
}

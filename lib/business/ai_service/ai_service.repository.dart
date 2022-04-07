import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';

class AIServiceRepository {
  final RemoteInterface remoteInterface = getIt.get<RemoteInterface>();

  Future<ConsumptionOptimizationsForecastDto>
      getPhotovoltaicSelfConsumptionOptimizerForecast(
    Uri url,
    ConsumptionOptimizationsForecastBodyDto optimizationsForecastBody,
    String unit,
  ) async {
    Map<String, dynamic> result = await remoteInterface.post(
      url.replace(
        path:
            ApiProprties.AiServicePhotovoltaicSelfConsumptionOptimizerForecast,
        queryParameters: {"unit": unit},
      ),
      headers: null,
    );

    return ConsumptionOptimizationsForecastDto.fromJson(result);
  }
}

import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/crossconcern/utilities/properties/ai_service.proprieties.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';

class AIServiceRepository implements AIServiceInterface{
  final RemoteInterface remoteInterface = getIt.get<RemoteInterface>();

  @override
  Future<ConsumptionOptimizationsForecastDto>
      getPhotovoltaicSelfConsumptionOptimizerForecast(
    Uri url,
    ConsumptionOptimizationsForecastBodyDto optimizationsForecastBody,
    String unit,
  ) async {
    Map<String, dynamic> result = await remoteInterface.post(
      url.replace(
        path: ApiProprties
            .aiServicePhotovoltaicSelfConsumptionOptimizerForecastPath,
        queryParameters: {"unit": unit},
      ),
      headers: {
        "Authorization": AiServiceProprieties.token,
      },
      body: optimizationsForecastBody.toJson(),
    );

    return ConsumptionOptimizationsForecastDto.fromJson(result);
  }

  @override
  Future<DailyPlanDto> getDailyPlan(
    Uri url,
    DailyPlanBodyDto dailyPlanBodyDto,
    int deviceNumber,
    List<String> entitysType,
  ) async {
    Map<String, dynamic> result = await remoteInterface.post(
      url.replace(
        path: ApiProprties.aiServiceDailyPlanPath,
        queryParameters: {"n": deviceNumber, "device": entitysType},
      ),
      headers: {
        "Authorization": AiServiceProprieties.token,
      },
      body: dailyPlanBodyDto.toJson(),
    );

    return DailyPlanDto.fromJson(result);
  }
}

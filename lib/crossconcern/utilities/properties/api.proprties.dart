class ApiProprties {
  static const aIServiceBaseUrl = "http://staging.aiservice.homsai.app:8080";
  static const aiServicePhotovoltaicSelfConsumptionOptimizerForecast =
      "/aiservice/forecast/photovoltaic/self-consumption";
  static const aiServiceDailyPlanPath = "/aiservice/statistics/suggestions/dailyplan";
  static const aiServiceLoginPath = "/aiservice/auth/login";
}

class HomeAssistantApiProprties {
  static const authClientId = "http://authcallback.homsai.app";
  static const authCallbackScheme = "homsai";
  static const authResponseType = "code";
  static const authPath = '/auth/authorize';

  static const tokenPath = "/auth/token";
  static const tokenContentType = "application/x-www-form-urlencoded";
  static const tokenGrantType = "authorization_code";
  static const tokenRefresh = "refresh_token";
  static const tokenRevoke = "revoke";

  static const authRequired = "auth_required";
  static const authOk = "auth_ok";
  static const authInvalid = "auth_invalid";

  static const webSocketPath = "/api/websocket";

  static const eventStateChanged = "state_changed";
  static const eventAutomationTriggered = "automation_triggered";
  static const eventScriptStarted = "script_started";
  static const eventServiceRegistered = "service_registered";
  static const eventServiceRemoved = "service_removed";
  static const eventHomeAssistantStart = "home_assistant_start";
  static const eventHomeAssistantStop = "home_assistant_stop";
  static const eventCoreConfigUpdated = "core_config_updated";
  static const eventComponentLoaded = "component_loaded";
  static const eventPersistentNotificationsUpdated =
      "persistent_notifications_updated";

  static const fetchingStates = "get_states";
  static const fetchingConfig = "get_config";
  static const fetchingServices = "get_services";
  static const fetchingMediaPlayerThumbnail = "media_player_thumbnail";
  static const fetchingAuthCurrentUser = "auth/current_user";
  static const fetchingPersistentNotificationGet =
      "persistent_notification/get";
  static const fetchingEnergyGetPrefs = "energy/get_prefs";
  static const fetchingEnergyInfo = "energy/info";
  static const fetchingSubscribeTrigger = "subscribe_trigger";
  static const fetchingSubscribeEvents = "subscribe_events";
  static const fetchingUnsubscribeEvents = "unsubscribe_events";
  static const fetchingHistoryStatisticsDuringPeriod =
      "history/statistics_during_period";

  static const fireEvent = "fire_event";
  static const callService = "call_service";
  static const validateConfig = "validate_config";

  static const historyPath = "/api/history/period";
  static const logbookPath = "/api/logbook";
}

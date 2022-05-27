// application name
const String appName = 'Homsai';

// height of the 'Homsai' header
const double homsaiHeaderHeight = 64;

// The splash page animation duration.
const splashPageAnimationDurationInMilliseconds = 300;

// Bug report's url
const bugReportUrl =
    "https://homsai-app.atlassian.net/servicedesk/customer/portal/1/create/1";

// Map indicating which chart to show
const Map<String, GraphicTypes> mapSuggestionsChart = {
  "CONSUMPTION_OPTIMIZATIONS": GraphicTypes.consumptionOptimizations,
  "PV_FORECAST": GraphicTypes.pvForecast,
};

// Type of home page graphic charts
enum GraphicTypes { consumptionOptimizations, pvForecast }

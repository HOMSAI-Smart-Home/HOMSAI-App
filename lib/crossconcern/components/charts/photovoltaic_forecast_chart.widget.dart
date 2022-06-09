import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homsai/crossconcern/components/utils/dialog.widget.dart';
import 'package:homsai/crossconcern/utilities/util/plot.util.dart';
import 'package:homsai/main.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:timezone/timezone.dart';

class PhotovoltaicForecastChart extends StatelessWidget {
  static final emptyPlot = Plot.sample(
      [const FlSpot(0, 0)], 0, Duration.minutesPerDay.toDouble(), 10);

  static const defaultMinRange = Offset.zero;
  static final defaultMaxRange = Offset(Duration.minutesPerDay.toDouble(), 6.0);
  static const spanRatio = 0.2;

  final double barWidth = 1;
  final bool isCurved = true;

  final List<FlSpot>? forecastData;
  final Offset? min;
  final Offset? max;

  const PhotovoltaicForecastChart(
      {Key? key, this.forecastData, required this.min, required this.max})
      : super(key: key);

  Widget photovoltaicDialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...dialogParagraph(
            HomsaiLocalizations.of(context)!.photovoltaicChartDialogDescription,
            title: HomsaiLocalizations.of(context)!
                .photovoltaicChartDialogDescriptionHeadline,
          ),
          Text(
            HomsaiLocalizations.of(context)!
                .photovoltaicChartDialogLegendaTitle,
            style: const TextStyle(color: HomsaiColors.primaryGreen),
          ),
          bulletListItem(
              HomsaiLocalizations.of(context)!
                  .photovoltaicChartDialogLegendaStraightLineTitle,
              HomsaiLocalizations.of(context)!
                  .photovoltaicChartDialogLegendaStraightLineMessage),
          bulletListItem(
              HomsaiLocalizations.of(context)!
                  .photovoltaicChartDialogLegendaDashedLineTitle,
              HomsaiLocalizations.of(context)!
                  .photovoltaicChartDialogLegendaDashedLineMessage),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 10, bottom: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    HomsaiLocalizations.of(context)!
                        .photovoltaicChartDialogTitle,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: ShowDialog(
                          title: HomsaiLocalizations.of(context)!
                              .photovoltaicChartTitle,
                          child: SvgPicture.asset("assets/icons/help.svg"),
                          content: photovoltaicDialogContent),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Flexible(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    _legenda(
                        HomsaiLocalizations.of(context)!
                            .photovoltaicChartLegendaSolarPanels,
                        HomsaiColors.primaryGreen),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  HomsaiLocalizations.of(context)!.dailyCosumptionChartPower,
                  style: const TextStyle(
                    color: HomsaiColors.primaryGrey,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 30,
          ),
          child: SizedBox(
            height: 180,
            child: LineChart(
              chartData,
              swapAnimationDuration: const Duration(milliseconds: 400),
              swapAnimationCurve: Curves.ease,
            ),
          ),
        ),
      ],
    );
  }

  Widget _legenda(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            color: color,
            width: 2,
            height: 2,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  LineChartData get chartData => LineChartData(
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        lineTouchData: lineTouchData,
        minX: min?.dx ?? defaultMinRange.dx,
        maxX: max?.dx ?? defaultMaxRange.dx,
        minY: min?.dy ?? defaultMinRange.dy,
        maxY: max?.dy.ceilToDouble() ?? defaultMaxRange.dy,
      );

  LineTouchData get lineTouchData => LineTouchData(
        enabled: false,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
                FlLine(
                  color: Colors.transparent,
                ),
                currentDayIndicator);
          }).toList();
        },
      );

  FlDotData get currentDayIndicator => FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          strokeWidth: 2.5,
          strokeColor: HomsaiColors.primaryGreen,
          color: HomsaiColors.primaryWhite,
        ),
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: horizontalInterval,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: HomsaiColors.primaryGrey.withOpacity(0.5),
            strokeWidth: 1.5,
          );
        },
      );

  double get horizontalInterval =>
      math.max(1, ((max?.dy ?? 10) * spanRatio).floorToDouble());

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  bool canShowBottomTitle(double value) {
    int offset =
        (forecastData != null) ? getHourFromX(forecastData!.first.x) : 0;
    int hour = getHourFromX(value) - 3;
    return value.toInt() % Duration.minutesPerDay % 60 == 0 &&
        (hour.toInt()) % 4 == offset % 4;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style =
        const TextStyle(color: HomsaiColors.primaryWhite, fontSize: 10);
    Duration timezoneOffset =
        TZDateTime.now(getIt.get<Location>()).timeZoneOffset;
    int hour = (getHourFromX(value) +
            (((timezoneOffset.isNegative) ? -1 : 1) * timezoneOffset.inHours)) %
        24;
    String time = canShowBottomTitle(value) ? "$hour:00" : '';
    return Padding(
        child: Text(
          time,
          style: style,
        ),
        padding: const EdgeInsets.only(top: 10.0));
  }

  int getHourFromX(double value) {
    return (value.toInt() ~/ 60) % Duration.hoursPerDay;
  }

  static FlSpot getSpotFromTime(List<FlSpot>? forecastData, DateTime time) {
    return forecastData?.firstWhere(
          (element) => DateTime.fromMillisecondsSinceEpoch(
                  element.x.toInt() * Duration.millisecondsPerMinute)
              .isAfter(time),
          orElse: () => FlSpot.zero,
        ) ??
        FlSpot.zero;
  }

  static DateTime getDateTimeFromSpot(FlSpot spot) {
    return DateTime.fromMillisecondsSinceEpoch(
        spot.x.toInt() * Duration.millisecondsPerMinute);
  }

  FlSpot get currentTimeSpot => getSpotFromTime(forecastData, DateTime.now());

  SideTitles get leftTitles => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 30,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value <= 0 ||
        value.toInt() % horizontalInterval.toInt() != 0 ||
        (value.toInt() % (horizontalInterval.toInt() * 2)) == 0) {
      return Container();
    }

    TextStyle style = const TextStyle(
      color: HomsaiColors.primaryGrey,
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );

    return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Text(value.toInt().toString(),
            style: style, textAlign: TextAlign.end));
  }

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          top: BorderSide(
            color: HomsaiColors.primaryGrey.withOpacity(0.5),
          ),
          bottom: const BorderSide(
            width: 2.0,
            color: HomsaiColors.primaryWhite,
          ),
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        lineChartBarData_1,
        lineChartBarData_2,
      ];

  LineChartBarData get lineChartBarData_1 {
    var data = (forecastData != null)
        ? forecastData!.sublist(0, forecastData!.indexOf(currentTimeSpot))
        : null;
    return LineChartBarData(
      showingIndicators: [(data?.length ?? 1) - 1],
      spots: data,
      isCurved: isCurved,
      color: HomsaiColors.primaryGreen,
      barWidth: barWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: belowBarAreaData,
      aboveBarData: aboveBarAreaData,
    );
  }

  BarAreaData get belowBarAreaData => BarAreaData(
        show: true,
        gradient: belowBarAreaDataGradient,
        spotsLine: belowBarAreaSpotsLine,
      );

  LinearGradient get belowBarAreaDataGradient => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          HomsaiColors.primaryGreen.withOpacity(0.1),
          HomsaiColors.primaryGreen.withOpacity(0.8),
        ],
        stops: const [0, 1],
      );

  BarAreaSpotsLine get belowBarAreaSpotsLine => BarAreaSpotsLine(
      show: true,
      flLineStyle: dashedLine,
      checkToShowSpotLine: checkToShowSpotLine);

  BarAreaData get aboveBarAreaData => BarAreaData(
        show: true,
        color: Colors.transparent,
        spotsLine: BarAreaSpotsLine(
            show: true,
            flLineStyle: dashedLine,
            checkToShowSpotLine: checkToShowSpotLine),
      );

  bool checkToShowSpotLine(FlSpot spot) =>
      spot ==
      ((forecastData != null)
              ? forecastData!.sublist(0, forecastData!.indexOf(currentTimeSpot))
              : null)
          ?.last;

  FlLine get dashedLine => FlLine(
      color: HomsaiColors.primaryWhite, strokeWidth: 1, dashArray: [3, 3]);

  LineChartBarData get lineChartBarData_2 => LineChartBarData(
        spots: (forecastData != null)
            ? forecastData!.sublist(forecastData!.indexOf(currentTimeSpot))
            : null,
        isCurved: isCurved,
        color: HomsaiColors.primaryGreen,
        barWidth: barWidth,
        isStrokeCapRound: false,
        dotData: FlDotData(show: false),
        dashArray: [5, 3],
      );

  Shadow get shadow => Shadow(
        color: Colors.black.withOpacity(0.8),
        offset: const Offset(0, 2),
        blurRadius: 4,
      );
}

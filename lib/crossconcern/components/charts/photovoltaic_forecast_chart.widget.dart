import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:homsai/crossconcern/utilities/util/plot.util.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart' as sh;

class PhotovoltaicForecastChart extends StatelessWidget {
  static final emptyPlot = Plot.sample(
      [const FlSpot(0, 0)], 0, Duration.minutesPerDay.toDouble(), 10);

  static const defaultMinRange = Offset.zero;
  static final defaultMaxRange = Offset(Duration.minutesPerDay.toDouble(), 6.0);

  final double barWidth = 1;
  final bool isCurved = true;

  final List<FlSpot>? forecastData;
  final FlSpot? currentForecastData;
  final Offset? min;
  final Offset? max;

  const PhotovoltaicForecastChart(
      {Key? key,
      this.forecastData,
      this.currentForecastData,
      required this.min,
      required this.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                HomsaiLocalizations.of(context)!.dailyCosumptionChartPower,
                style: TextStyle(
                  color: HomsaiColors.primaryGrey,
                  fontSize: 9,
                ),
              ),
              Flexible(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  verticalDirection: VerticalDirection.up,
                  children: [
                    _legenda(
                        HomsaiLocalizations.of(context)!
                            .dailyCosumptionChartLegendaSolarPanels,
                        HomsaiColors.primaryGreen),
                  ],
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
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: HomsaiColors.primaryGrey.withOpacity(0.5),
            strokeWidth: 1,
          );
        },
      );

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

  bool canShowBottomTitle(int value) {
    int hour = (value.toInt() ~/ 60) - 2;
    return value % 60 == 0 && hour >= 0 && hour < 22 && hour.toInt() % 4 == 0;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(color: HomsaiColors.primaryWhite, fontSize: 10);
    int hour = (value.toInt() ~/ 60);
    String time = canShowBottomTitle(value.toInt()) ? "$hour:00" : '';
    return Padding(
        child: Text(
          time,
          style: style,
        ),
        padding: const EdgeInsets.only(top: 10.0));
  }

  SideTitles get leftTitles => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 30,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: HomsaiColors.primaryGrey,
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );
    if (value <= 0 || value % 2 != 0) return Container();

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
          bottom: BorderSide(
            width: 2.0,
            color: HomsaiColors.primaryWhite,
          ),
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        lineChartBarData_1,
        lineChartBarData_2,
      ];

  LineChartBarData get lineChartBarData_1 => LineChartBarData(
        spots: (forecastData != null)
            ? forecastData!
                .sublist(0, forecastData!.indexOf(currentForecastData!))
            : null,
        isCurved: isCurved,
        color: HomsaiColors.primaryGreen,
        barWidth: barWidth,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: belowBarAreaData,
        aboveBarData: aboveBarAreaData,
      );

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

  bool checkToShowSpotLine(FlSpot spot) => spot == currentForecastData;

  FlLine get dashedLine => FlLine(
      color: HomsaiColors.primaryWhite, strokeWidth: 2, dashArray: [5, 5]);

  LineChartBarData get lineChartBarData_2 => LineChartBarData(
        showingIndicators: [0],
        spots: (forecastData != null)
            ? forecastData!.sublist(forecastData!.indexOf(currentForecastData!))
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

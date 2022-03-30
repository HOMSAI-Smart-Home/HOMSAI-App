import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/widget/shadow.widget.dart' as sh;

class ConsumptionChart extends StatelessWidget {
  const ConsumptionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sh.Shadow(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      sigma: 1,
      offset: const Offset(0, 2),
      color: Theme.of(context).colorScheme.primary,
      child: SizedBox(
        height: 180,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 28),
            child: LineChart(chartData),
          ),
        ),
      ),
    );
  }
}

LineChartData get chartData => LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: 0,
      maxX: 21,
      minY: 0,
      maxY: 6,
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

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  TextStyle style = TextStyle(
      color: (value.toInt() != 11)
          ? HomsaiColors.primaryWhite
          : HomsaiColors.primaryGreen,
      fontSize: 10);
  Widget text;
  switch (value.toInt()) {
    case 2:
      text = Text(
        'LUN',
        style: style,
      );
      break;
    case 5:
      text = Text(
        'MAR',
        style: style,
      );
      break;
    case 8:
      text = Text(
        'MER',
        style: style,
      );
      break;
    case 11:
      text = Text(
        'GIO',
        style: style,
      );
      break;
    case 14:
      text = Text(
        'VEN',
        style: style,
      );
      break;
    case 17:
      text = Text(
        'SAB',
        style: style,
      );
      break;
    case 20:
      text = Text(
        'DOM',
        style: style,
      );
      break;
    default:
      text = const Text('');
      break;
  }

  return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
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
  String text;
  switch (value.toInt()) {
    case 1:
      text = '1';
      break;
    case 3:
      text = '2,9';
      break;
    case 5:
      text = '10k';
      break;
    default:
      return Container();
  }

  return Padding(
      padding: EdgeInsets.only(right: 6),
      child: Text(text, style: style, textAlign: TextAlign.end));
}

FlBorderData borderData = FlBorderData(
  show: true,
  border: Border(
    top: BorderSide(color: HomsaiColors.primaryGrey.withOpacity(0.5)),
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
      spots: const [
        FlSpot(0, 3),
        FlSpot(2.6, 2),
        FlSpot(4.9, 5),
        FlSpot(6.8, 3.1),
        FlSpot(8, 4),
        FlSpot(9.5, 3),
        FlSpot(11, 4),
      ],
      isCurved: true,
      color: HomsaiColors.primaryGreen,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: belowBarAreaData,
      aboveBarData: aboveBarAreaData,
      shadow: shadow,
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
    checkToShowSpotLine: (spot) => spot == const FlSpot(11, 4));

BarAreaData get aboveBarAreaData => BarAreaData(
      show: true,
      color: Colors.transparent,
      spotsLine: BarAreaSpotsLine(
          show: true,
          flLineStyle: dashedLine,
          checkToShowSpotLine: (spot) => spot == const FlSpot(11, 4)),
    );

FlLine get dashedLine =>
    FlLine(color: HomsaiColors.primaryWhite, strokeWidth: 2, dashArray: [5, 5]);

LineChartBarData get lineChartBarData_2 => LineChartBarData(
      showingIndicators: [0],
      spots: const [
        FlSpot(11, 4),
        FlSpot(12, 3),
        FlSpot(12.6, 2),
        FlSpot(14.9, 5),
        FlSpot(16.8, 3.1),
        FlSpot(18, 4),
        FlSpot(19.5, 3),
        FlSpot(21, 4),
      ],
      isCurved: true,
      color: HomsaiColors.primaryGreen,
      barWidth: 3,
      isStrokeCapRound: false,
      dotData: FlDotData(show: false),
      dashArray: [15, 5],
    );

Shadow get shadow => Shadow(
      color: Colors.black.withOpacity(0.8),
      offset: const Offset(0, 2),
      blurRadius: 4,
    );

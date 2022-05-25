import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';

class Plot {
  static List<FlSpot> plotFromList<T>(
      List<T> list, double Function(T) x, double Function(T) y) {
    return list.map((item) => FlSpot(x(item), y(item))).toList();
  }

  static List<FlSpot> sample(
    List<FlSpot> plot,
    double start,
    double end,
    double samplingInterval, {
    FlSpot Function(List<FlSpot>, double) strategy = sampleStrategyFirstWhere,
  }) {
    List<FlSpot> sampledPlot = [];
    if (plot.isNotEmpty) {
      final startSpot = plot.first;
      double current = startSpot.x;

      for (current; current < start; current += samplingInterval) {
        sampledPlot.add(startSpot);
      }

      for (current; current < end; current += samplingInterval) {
        sampledPlot.add(FlSpot(current, strategy(plot, current).y));
      }
    }
    return sampledPlot;
  }

  static FlSpot sampleStrategyFirstWhere(List<FlSpot> plot, double value) {
    return plot.lastWhere((spot) => spot.x <= value, orElse: () => plot.last);
  }

  static List<FlSpot> intersect(List<FlSpot> plotA, List<FlSpot> plotB) {
    List<FlSpot> intersection = [];
    if (plotA.length != plotB.length) return intersection;
    for (int i = 0; i < plotA.length; i++) {
      final spotA = plotA[i];
      final spotB = plotB[i];
      final intersectSpot = FlSpot(spotA.x, math.min(spotA.y, spotB.y));
      intersection.add(intersectSpot);
    }
    return intersection;
  }

  static List<FlSpot> stack(List<FlSpot> plotA, List<FlSpot> plotB) {
    List<FlSpot> stack = [];
    if (plotA.length != plotB.length) return stack;
    for (int i = 0; i < plotA.length; i++) {
      final spotA = plotA[i];
      final spotB = plotB[i];
      final intersectSpot = FlSpot(spotA.x, spotA.y + math.max(0, spotB.y));
      stack.add(intersectSpot);
    }
    return stack;
  }

  static FlSpot min(List<FlSpot> plot) {
    if (plot.isEmpty) return FlSpot.nullSpot;

    return plot.reduce((previousValue, element) =>
        (previousValue.y < element.y) ? previousValue : element);
  }

  static FlSpot max(List<FlSpot> plot) {
    if (plot.isEmpty) return FlSpot.nullSpot;

    return plot.reduce((previousValue, element) =>
        (previousValue.y > element.y) ? previousValue : element);
  }
}

extension FlSpotX on FlSpot {}

extension PlotListX on List<FlSpot> {
  List<FlSpot> sample(
    double start,
    double end,
    double samplingInterval, {
    FlSpot Function(List<FlSpot>, double) strategy =
        Plot.sampleStrategyFirstWhere,
  }) {
    return Plot.sample(this, start, end, samplingInterval, strategy: strategy);
  }

  List<FlSpot> intersect(List<FlSpot> plot) {
    return Plot.intersect(this, plot);
  }

  List<FlSpot> stack(List<FlSpot> plot) {
    return Plot.stack(this, plot);
  }

  FlSpot get min => Plot.min(this);

  FlSpot get max => Plot.max(this);
}

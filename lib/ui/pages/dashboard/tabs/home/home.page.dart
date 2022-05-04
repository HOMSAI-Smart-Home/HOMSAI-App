import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/charts/daily_consumption_chart.widget.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:homsai/crossconcern/components/utils/toggle_text.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:homsai/ui/widget/devices/light/light_device.widget.dart';
import 'package:super_rich_text/super_rich_text.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchStates());
    if (!context.read<WebSocketBloc>().webSocketRepository.isConnected()) {
      context.read<WebSocketBloc>().add(ConnectWebSocket(
        onWebSocketConnected: () {
          context.read<HomeBloc>().add(FetchHistory());
        },
      ));
    } else {
      context.read<HomeBloc>().add(FetchHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*Alert(
            AlertType.tips,
            icon: SvgPicture.asset(
                    "assets/icons/tips.svg",
                  ),
            title: Text(
              HomsaiLocalizations.of(context)!
                  .homePageImprovementAvailableLabel,
              style: Theme.of(context).textTheme.headline3,
            ),
            message: SuperRichText(
              text: HomsaiLocalizations.of(context)!
                  .homePageMockTurnOffLightLabel,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            action: AlertAction("Details", () {}),
          ),*/
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: DailyConsumptionChartInfo(),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 2,
                    childAspectRatio: 150 / 90,
                  ),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.lights.length,
                  itemBuilder: (BuildContext context, index) {
                    return BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                      return LightDevice(light: state.lights[index]);
                    });
                  });
            },
          ),
          const SizedBox(height: 12)
        ],
      ),
    );
  }
}

class DailyConsumptionChartInfo extends StatelessWidget {
  const DailyConsumptionChartInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Shadow(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          sigma: 1,
          offset: const Offset(0, 2),
          color: HomsaiColors.primaryGrey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ToggleText(
                      key: ValueKey(state.isPlotOptimized),
                      first: HomsaiLocalizations.of(context)!
                          .homePageCurrentConsumptionLabel,
                      second: HomsaiLocalizations.of(context)!
                          .homePageOptimizedConsumptionLabel,
                      onChanged: (isNormalPlot) {
                        context.read<HomeBloc>().add(
                            ToggleConsumptionOptimazedPlot(
                                isOptimized: !isNormalPlot));
                      },
                      isFirstEnabled: !state.isPlotOptimized,
                    ),
                  ),
                  DailyConsumptionChart(
                    autoConsumptionPlot: state.autoConsumption,
                    consumptionPlot: (state.isPlotOptimized)
                        ? state.optimizedConsumptionPlot
                        : state.consumptionPlot,
                    productionPlot: state.productionPlot,
                    max: state.maxOffset,
                    min: state.minOffset,
                  ),
                  const DailyConsumptionBalanceInfo(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DailyConsumptionBalanceInfo extends StatelessWidget {
  const DailyConsumptionBalanceInfo({Key? key}) : super(key: key);

  PVBalanceDto? balance(HomeState state) {
    return (state.isPlotOptimized) ? state.optimizedBalance : state.balance;
  }

  double balanceWithHomesai(HomeState state) {
    return double.parse(state.optimizedBalance!.balance.toStringAsFixed(2)) -
        double.parse(state.balance!.balance.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (balance(state) != null)
              DailyConsumptionBalanceItemInfo(
                HomsaiLocalizations.of(context)!.homePagePurchasedEnergyLabel,
                amount: balance(state)!.boughtEnergyExpense,
                power: balance(state)!.boughtEnergy,
                unit: state.consumptionSensor!.unitMesurement,
              ),
            if (balance(state) != null)
              DailyConsumptionBalanceItemInfo(
                HomsaiLocalizations.of(context)!.homePageEnergyInjectedLabel,
                amount: balance(state)!.soldEnergyEarning,
                power: balance(state)!.soldEnergy,
                unit: state.productionSensor!.unitMesurement,
              ),
            if (balance(state) != null)
              DailyConsumptionBalanceItemInfo(
                HomsaiLocalizations.of(context)!.homePageBalanceLabel,
                amount: balance(state)!.balance,
                colored: true,
              ),
            if (balance(state) != null)
              EarnWithHomsaiItemInfo(
                HomsaiLocalizations.of(context)!.homePageEarnWithHomesaiLabel,
                amount: balanceWithHomesai(state),
                alertTextContent: HomsaiLocalizations.of(context)!
                    .homePageBalanceAlertContent,
                alertTextTitle:
                    HomsaiLocalizations.of(context)!.homePageBalanceAlertTitle,
              ),
          ],
        ),
      ),
    );
  }
}

class DailyConsumptionBalanceItemInfo extends StatelessWidget {
  const DailyConsumptionBalanceItemInfo(
    this.label, {
    Key? key,
    required this.amount,
    this.power,
    this.unit,
    this.colored = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final String label;
  final double amount;
  final double? power;
  final String? unit;
  final bool colored;
  final Color? backgroundColor;
  final Color? textColor;

  Color? getColored(BuildContext context) {
    if (colored && amount != 0) {
      return (amount < 0) ? HomsaiColors.primaryRed : HomsaiColors.primaryGreen;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(38),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor ??
                        Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${amount.toStringAsFixed(2)} €",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: getColored(context)),
                  ),
                  if (power != null)
                    Text(
                      "${power!.toStringAsFixed(1)} $unit",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EarnWithHomsaiItemInfo extends StatelessWidget {
  const EarnWithHomsaiItemInfo(
    this.label, {
    Key? key,
    required this.amount,
    this.alertTextContent,
    this.alertTextTitle,
  }) : super(key: key);

  final String label;
  final double amount;
  final String? alertTextContent;
  final String? alertTextTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: HomsaiColors.primaryGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(38),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => HomsaiColors.primaryGreen)),
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text(
                          alertTextContent ??
                              HomsaiLocalizations.of(context)!
                                  .homePageBalanceAlertContentDefault,
                          style: TextStyle(color: HomsaiColors.primaryWhite),
                        ),
                        title: Text(
                          alertTextTitle ??
                              HomsaiLocalizations.of(context)!
                                  .homePageBalanceAlertTitleDefault,
                          style: TextStyle(color: HomsaiColors.primaryWhite),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ))
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: HomsaiColors.primaryWhite),
                    ),
                    SvgPicture.asset("assets/icons/help.svg"),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${amount.toStringAsFixed(2)} €",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: HomsaiColors.primaryWhite),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Boolean {}

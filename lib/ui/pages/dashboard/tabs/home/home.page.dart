import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/charts/daily_consumption_chart.widget.dart';
import 'package:homsai/crossconcern/components/charts/photovoltaic_forecast_chart.widget.dart';
import 'package:homsai/crossconcern/components/utils/dialog.widget.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:homsai/crossconcern/components/utils/toggle_text.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/utilities/properties/connection.properties.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.util.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:homsai/ui/widget/devices/light/light_device.widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart' as rive;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    context.read<WebSocketBloc>().add(ConnectWebSocket(
      onWebSocketConnected: () {
        if (mounted) {
          context.read<HomeBloc>().add(const RemoveAlert(
              ConnectionProperties.noHomeAssistantConnectionAlertKey));
          context.read<HomeBloc>().add(FetchStates());
          context.read<HomeBloc>().add(FetchSuggestionsChart());
        }
      },
    ));

    context.read<WebSocketBloc>().subscribeToReconnect((){
      context.read<HomeBloc>().add(const RemoveAlert(
              ConnectionProperties.noHomeAssistantConnectionAlertKey));
          context.read<HomeBloc>().add(FetchStates());
          context.read<HomeBloc>().add(FetchSuggestionsChart());
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          context.read<HomeBloc>().onActive();
          context.read<HomeBloc>().add(FetchStates());
          context.read<HomeBloc>().add(FetchHistory());
          break;
        default:
          context.read<HomeBloc>().onInactive();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ActiveAlert(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _getHomeGraphicChart(state),
              ),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) =>
                    previous.lights.length != current.lights.length,
                builder: (context, state) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        buildWhen: (previous, current) =>
                            previous.lights[index] != current.lights[index],
                        builder: (context, state) {
                          return LightDevice(
                            key: ValueKey(state.lights[index]),
                            light: state.lights[index],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12)
            ],
          );
        },
      ),
    );
  }
}

class ActiveAlert extends StatelessWidget {
  const ActiveAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return generateActiveAlert(state, context);
    });
  }
}

Widget generateActiveAlert(HomeState state, BuildContext context) {
  return Column(
    children: [if (state.alerts.isNotEmpty) state.alerts.values.toList().first],
  );
}

Widget _getHomeGraphicChart(HomeState state) {
  Widget homeGraphicChart;

  switch (_checkActualGraphicChart(state)) {
    case GraphicStates.photovoltaic:
      homeGraphicChart = const PhotovoltaicForecastChartInfo();
      break;
    case GraphicStates.optimizedConsumption:
      homeGraphicChart = const DailyConsumptionChartInfo();
      break;
    default:
      homeGraphicChart = const _LoadingErrorWidget();
      break;
  }
  return homeGraphicChart;
}

GraphicStates _checkActualGraphicChart(HomeState state) {
  if (state.isLoading) {
    return GraphicStates.loading;
  }
  if (state.activeGraphicChart == GraphicTypes.consumptionOptimizations &&
      state.optimizedConsumptionPlot != null &&
      state.consumptionPlot != null &&
      state.productionPlot != null) {
    return GraphicStates.optimizedConsumption;
  }

  if (state.activeGraphicChart == GraphicTypes.pvForecast &&
      state.forecastData.isNotEmpty) {
    return GraphicStates.photovoltaic;
  }

  return GraphicStates.error;
}

class _LoadingErrorWidget extends StatelessWidget {
  const _LoadingErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SizedBox(
          height: 193,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _HourglassIcon(),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: (state.isLoading)
                    ? Text(
                        HomsaiLocalizations.of(context)!
                            .dailyCosumptionChartLoadingLabel,
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        HomsaiLocalizations.of(context)!
                            .dailyCosumptionChartErrorLabel,
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
              )
            ],
          ),
        );
      },
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
                    chargePlot: state.chargePlot,
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

class PhotovoltaicForecastChartInfo extends StatelessWidget {
  const PhotovoltaicForecastChartInfo({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhotovoltaicForecastChart(
                    forecastData: state.forecastData,
                    min: state.forecastMinOffset,
                    max: state.forecastMaxOffset,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HourglassIcon extends StatefulWidget {
  const _HourglassIcon({Key? key}) : super(key: key);

  @override
  _HourglassIconState createState() => _HourglassIconState();
}

class _HourglassIconState extends State<_HourglassIcon> {
  rive.SMIInput<bool>? _error;

  void _onHouglassInit(rive.Artboard artboard) {
    final controller =
        rive.StateMachineController.fromArtboard(artboard, 'spin');
    if (controller != null) {
      artboard.addController(controller);
      _error = controller.findInput<bool>('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            _error?.value = !state.isLoading;
          },
          child: SizedBox(
            width: 48,
            height: 48,
            child: rive.RiveAnimation.asset(
              "assets/animations/hourglass.riv",
              stateMachines: const [''],
              onInit: _onHouglassInit,
            ),
          ));
    });
  }
}

class DailyConsumptionBalanceInfo extends StatelessWidget {
  const DailyConsumptionBalanceInfo({Key? key}) : super(key: key);

  PVBalanceDto? balance(HomeState state) {
    return (state.isPlotOptimized) ? state.optimizedBalance : state.balance;
  }

  double? balanceWithHomesai(HomeState state) {
    if (state.optimizedBalance != null && state.balance != null) {
      return double.parse(state.optimizedBalance!.balance.toStringAsFixed(2)) -
          double.parse(state.balance!.balance.toStringAsFixed(2));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) =>
            Column(mainAxisSize: MainAxisSize.min, children: [
          DailyConsumptionBalanceItemInfo(
            HomsaiLocalizations.of(context)!.homePagePurchasedEnergyLabel,
            amount: balance(state)?.boughtEnergyExpense,
            power: balance(state)?.boughtEnergy,
            unit: state.consumptionSensor?.unitMesurement,
          ),
          DailyConsumptionBalanceItemInfo(
            HomsaiLocalizations.of(context)!.homePageEnergyInjectedLabel,
            amount: balance(state)?.soldEnergyEarning,
            power: balance(state)?.soldEnergy,
            unit: state.productionSensor?.unitMesurement,
          ),
          DailyConsumptionBalanceItemInfo(
            HomsaiLocalizations.of(context)!.homePageBalanceLabel,
            amount: balance(state)?.balance,
            colored: true,
          ),
          EarnWithHomsaiItemInfo(amount: balanceWithHomesai(state)),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}

class DailyConsumptionBalanceItemInfo extends StatelessWidget {
  const DailyConsumptionBalanceItemInfo(
    this.label, {
    Key? key,
    this.amount,
    this.power,
    this.unit,
    this.colored = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final String label;
  final double? amount;
  final double? power;
  final String? unit;
  final bool colored;
  final Color? backgroundColor;
  final Color? textColor;

  Color? getColored(BuildContext context) {
    if (colored && amount != null && amount != 0) {
      return (amount! < 0)
          ? HomsaiColors.primaryRed
          : HomsaiColors.primaryGreen;
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
        size: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: textColor ??
                        Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (amount != null) ? "${amount!.toStringAsFixed(2)} €" : "--",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1,
                        color: getColored(context)),
                  ),
                  if (power != null)
                    Text(
                      (power != null && unit != null)
                          ? "${power!.toStringAsFixed(1)} $unit"
                          : "--",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            height: 1,
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
  const EarnWithHomsaiItemInfo({
    Key? key,
    this.amount,
  }) : super(key: key);
  final double? amount;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: HomsaiColors.primaryGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox.fromSize(
          size: const Size.fromHeight(40),
          child: ShowDialog(
            title: HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogTitle,
            content: earnWithHomsaiDialogContent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        HomsaiLocalizations.of(context)!
                            .homePageEarnWithHomesaiLabel,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1,
                            color: HomsaiColors.primaryWhite),
                      ),
                      SvgPicture.asset("assets/icons/help.svg"),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (amount != null)
                            ? "${amount!.toStringAsFixed(2)} €"
                            : HomsaiLocalizations.of(context)!
                                .homePageBalanceDefaultPlaceholder,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1,
                            color: HomsaiColors.primaryWhite),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

Widget earnWithHomsaiDialogContent(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...dialogParagraph(
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP1Content,
          title: HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP1Title,
        ),
        ...dialogParagraph(
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP2Content,
          title: HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP2Title,
        ),
        ...dialogParagraph(
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP3Content,
          title: HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP3Title,
        ),
        ...dialogParagraph(
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP4Content,
            title: HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP4Title,
            removeBottomPadding: true),
        bulletListItem(
          HomsaiLocalizations.of(context)!
              .dailyCosumptionChartLegendaSolarPanels,
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogBulletListContent1,
          color: HomsaiColors.primaryGreen,
        ),
        bulletListItem(
          HomsaiLocalizations.of(context)!
              .dailyCosumptionChartLegendaConsumption,
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogBulletListContent2,
          color: HomsaiColors.primaryYellow,
        ),
        ...dialogParagraph(
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP5Content,
            removeBottomPadding: true),
        bulletListItem(
            HomsaiLocalizations.of(context)!
                .dailyCosumptionChartLegendaAvailable,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListContent3,
            color: HomsaiColors.primaryGreen),
        bulletListItem(
          HomsaiLocalizations.of(context)!
              .dailyCosumptionChartLegendaSelfConsumption,
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogBulletListContent4,
          color: HomsaiColors.primaryBlue,
        ),
        bulletListItem(
          HomsaiLocalizations.of(context)!
              .dailyCosumptionChartLegendaSelfPurchased,
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogBulletListContent5,
          color: HomsaiColors.primaryRed,
        ),
        const SizedBox(height: 15),
        ...dialogParagraph(
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP6Content,
            removeBottomPadding: true),
        ...dialogParagraph(HomsaiLocalizations.of(context)!
            .homePageEarnWithHomesaiDialogP7Content),
        ...dialogParagraph(HomsaiLocalizations.of(context)!
            .homePageEarnWithHomesaiDialogP8Content),
      ],
    ),
  );
}

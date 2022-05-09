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
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart' as rive;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //context.read<HomeBloc>().add(FetchStates());
    context.read<WebSocketBloc>().add(ConnectWebSocket(
      onWebSocketConnected: () {
        context.read<HomeBloc>().add(FetchStates());
        context.read<HomeBloc>().add(FetchHistory());
      },
    ));
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
                  generateChartGraphics(state, context),
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

Widget generateChartGraphics(HomeState state, BuildContext context) {
  if (state.isLoading) {
    return SizedBox(
      height: 193,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _HourglassIcon(),
          const SizedBox(height: 5),
          Text(
            "Recupero dati...",
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
  return (state.optimizedConsumptionPlot != null &&
          state.consumptionPlot != null &&
          state.productionPlot != null)
      ? DailyConsumptionChart(
          autoConsumptionPlot: state.autoConsumption,
          consumptionPlot: (state.isPlotOptimized)
              ? state.optimizedConsumptionPlot
              : state.consumptionPlot,
          productionPlot: state.productionPlot,
          max: state.maxOffset,
          min: state.minOffset,
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: Text(
                "Dati grafico non disponibili. Assicurati di aver collegato i sensori di consumo e produzione.",
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
}

class _HourglassIcon extends StatefulWidget {
  const _HourglassIcon({Key? key}) : super(key: key);

  @override
  _HourglassIconState createState() => _HourglassIconState();
}

class _HourglassIconState extends State<_HourglassIcon> {
  rive.SMIInput<bool>? _error;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 48,
      height: 48,
      child: rive.RiveAnimation.asset(
        "assets/animations/hourglass.riv",
        stateMachines: ['spin'],
      ),
    );
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
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    (amount != null) ? "${amount!.toStringAsFixed(2)} €" : "--",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w400,
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
        size: const Size.fromHeight(38),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: earnWithHomsaiDialogContent(context),
                      insetPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 24.0),
                        title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              HomsaiLocalizations.of(context)!
                                  .homePageEarnWithHomesaiDialogTitle,
                              style:
                                  TextStyle(color: HomsaiColors.primaryWhite),
                            ),
                          InkWell(
                            onTap: () => {Navigator.of(context).pop()},
                            borderRadius: BorderRadius.circular(5),
                            child:
                                SizedBox(
                                height: 30,
                                width: 30,
                                child:
                                    SvgPicture.asset("assets/icons/close.svg")),
                          )
                          ],
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ))
            },
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
                          : "--",
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

Widget earnWithHomsaiDialogContent(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...generateEarnWithHomsaiParagraph(
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP1Content,
          title: HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP1Title,
        ),
        ...generateEarnWithHomsaiParagraph(
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP2Content,
          title: HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP2Title,
        ),
        ...generateEarnWithHomsaiParagraph(
          HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP3Content,
          title: HomsaiLocalizations.of(context)!
              .homePageEarnWithHomesaiDialogP3Title,
        ),
        ...generateEarnWithHomsaiParagraph(
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP4Content,
            title: HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP4Title,
            removeBottomPadding: true),
        generateEarnWithHomsaiBulletListItem(
            HomsaiColors.primaryGreen,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListTitle1,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListContent1),
        generateEarnWithHomsaiBulletListItem(
            HomsaiColors.primaryYellow,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListTitle2,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListContent2),
        ...generateEarnWithHomsaiParagraph(
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP5Content,
            removeBottomPadding: true),
        generateEarnWithHomsaiBulletListItem(
            HomsaiColors.primaryGreen,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListTitle3,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListContent3),
        generateEarnWithHomsaiBulletListItem(
            HomsaiColors.primaryBlue,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListTitle4,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListContent4),
        generateEarnWithHomsaiBulletListItem(
            HomsaiColors.primaryRed,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListTitle5,
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogBulletListContent5),
        const SizedBox(height: 15),
        ...generateEarnWithHomsaiParagraph(
            HomsaiLocalizations.of(context)!
                .homePageEarnWithHomesaiDialogP6Content,
            removeBottomPadding: true),
        ...generateEarnWithHomsaiParagraph(HomsaiLocalizations.of(context)!
            .homePageEarnWithHomesaiDialogP7Content),
        ...generateEarnWithHomsaiParagraph(HomsaiLocalizations.of(context)!
            .homePageEarnWithHomesaiDialogP8Content),
      ],
    ),
  );
}

List<Widget> generateEarnWithHomsaiParagraph(
  String content, {
  bool? removeBottomPadding,
  String? title,
}) {
  return [
    if (title != null)
      Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(color: HomsaiColors.primaryGreen),
      ),
    const SizedBox(height: 5),
    Text(content,
        textAlign: TextAlign.left,
        style: TextStyle(color: HomsaiColors.primaryWhite)),
    if (removeBottomPadding != true) const SizedBox(height: 15),
  ];
}

Widget generateEarnWithHomsaiBulletListItem(
    Color color, String title, String content) {
  return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Bullet(),
        ],
      ),
      horizontalTitleGap: -25,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      title: Text.rich(TextSpan(children: [
        TextSpan(
          text: title,
          style: TextStyle(color: color),
        ),
        TextSpan(
            text: content, style: TextStyle(color: HomsaiColors.primaryWhite)),
      ])));
}

class Bullet extends StatelessWidget {
  const Bullet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.5,
      width: 2.5,
      decoration: BoxDecoration(
        color: HomsaiColors.primaryWhite,
      ),
    );
  }
}

//List<Widget> generateEarnWithHomsaiBulletedList(BuildContext context)

class Boolean {}

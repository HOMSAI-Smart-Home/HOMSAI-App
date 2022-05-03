import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/charts/daily_consumption_chart.widget.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:homsai/crossconcern/components/utils/toggle_text.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:homsai/ui/widget/devices/light/light_device.widget.dart';

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
    if(!context.read<WebSocketBloc>().webSocketRepository.isConnected()) {
      context.read<WebSocketBloc>().add(ConnectWebSocket(onWebSocketConnected: () {}));
    }
    /*
    BlocListener<WebSocketBloc, WebSocketState>(
      listenWhen: (previous, current) => previous,
      listener: (context, state) => context.read<HomeBloc>().add(FetchStates()),);*/
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*Alert(
            AlertType.tips,
            icon: const Icon(Icons.tips_and_updates_rounded),
            title: Text(
              "Miglioramento disponibile",
              style: Theme.of(context).textTheme.headline3,
            ),
            message: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
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
                      first: "Consumo attuale",
                      second: "Consumo ottimizzato",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: SizedBox.fromSize(
                      size: const Size.fromHeight(38),
                      child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("Cosa significa?")),
                    ),
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

class DailyConsumptionBalanceInfo extends StatelessWidget {
  const DailyConsumptionBalanceInfo({Key? key}) : super(key: key);

  PVBalanceDto? balance(HomeState state) {
    return (state.isPlotOptimized) ? state.optimizedBalance : state.balance;
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
                "Energia Acquistata",
                amount: balance(state)!.boughtEnergyExpense,
                power: balance(state)!.boughtEnergy,
                unit: state.consumptionSensor!.unitMesurement,
              ),
            if (balance(state) != null)
              DailyConsumptionBalanceItemInfo(
                "Energia Immessa",
                amount: balance(state)!.soldEnergyEarning,
                power: balance(state)!.soldEnergy,
                unit: state.productionSensor!.unitMesurement,
              ),
            if (balance(state) != null)
              DailyConsumptionBalanceItemInfo(
                "Saldo",
                amount: balance(state)!.balance,
                colored: true,
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
  }) : super(key: key);

  final String label;
  final double amount;
  final double? power;
  final String? unit;
  final bool colored;

  Color? getColored(BuildContext context) {
    if (colored && amount != 0) {
      return (amount < 0) ? HomsaiColors.primaryRed : HomsaiColors.primaryGreen;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
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

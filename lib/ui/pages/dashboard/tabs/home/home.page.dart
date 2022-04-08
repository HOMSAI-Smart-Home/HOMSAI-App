import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:homsai/crossconcern/components/alerts/alert.widget.dart';
import 'package:homsai/crossconcern/components/charts/consumption_chart.widget.dart';
import 'package:homsai/ui/widget/devices/light/light_device.widget.dart';
import 'package:super_rich_text/super_rich_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(ConnectWebSocket());
    context.read<HomeBloc>().add(FetchStates());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Alert(
            AlertType.tips,
            icon: const Icon(Icons.tips_and_updates_rounded),
            title: Text(
              "Miglioramento disponibile",
              style: Theme.of(context).textTheme.headline6,
            ),
            message: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            action: AlertAction("Details", () {}),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ConsumptionChart(),
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

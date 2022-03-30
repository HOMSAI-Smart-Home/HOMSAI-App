import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/widget/alert.widget.dart';
import 'package:homsai/ui/widget/consumption_chart.widget.dart';
import 'package:homsai/ui/widget/dashboard_device.widget.dart';
import 'package:super_rich_text/super_rich_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 2,
              childAspectRatio: 150 / 90,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                DashboardDevice(
                  DeviceStatus.disabled,
                  baseIcon: Icons.lightbulb,
                  baseColor: HomsaiColors.primaryYellow,
                  title: "Lampada Tavolo Lorem lorem kkkdldlasd",
                  room: "Camera",
                  info: "off",
                ),
                DashboardDevice(
                  DeviceStatus.disabled,
                  baseIcon: Icons.thermostat_rounded,
                  baseColor: HomsaiColors.primaryOrange,
                  title: "Clima Cucina",
                  room: "Cucina",
                  info: "22.3°",
                ),
                DashboardDevice(
                  DeviceStatus.enabled,
                  baseIcon: Icons.lightbulb,
                  baseColor: HomsaiColors.primaryYellow,
                  title: "Lampada Tavolo",
                  room: "Camera",
                  info: "off",
                ),
                DashboardDevice(
                  DeviceStatus.enabled,
                  baseIcon: Icons.thermostat_rounded,
                  baseColor: HomsaiColors.primaryOrange,
                  title: "Clima Cucina",
                  room: "Cucina",
                  info: "22.3°",
                ),
                DashboardDevice(
                  DeviceStatus.warning,
                  baseIcon: Icons.lightbulb,
                  baseColor: HomsaiColors.primaryYellow,
                  title: "Lampada Tavolo",
                  room: "Camera",
                  info: "off",
                ),
                DashboardDevice(
                  DeviceStatus.warning,
                  baseIcon: Icons.thermostat_rounded,
                  baseColor: HomsaiColors.primaryOrange,
                  title: "Clima Cucina",
                  room: "Cucina",
                  info: "22.3°",
                ),
                DashboardDevice(
                  DeviceStatus.error,
                  baseIcon: Icons.lightbulb,
                  baseColor: HomsaiColors.primaryYellow,
                  title: "Lampada Tavolo",
                  room: "Camera",
                  info: "off",
                ),
                DashboardDevice(
                  DeviceStatus.error,
                  baseIcon: Icons.thermostat_rounded,
                  baseColor: HomsaiColors.primaryOrange,
                  title: "Clima Cucina",
                  room: "Cucina",
                  info: "22.3°",
                ),
                DashboardDevice(
                  DeviceStatus.group,
                  baseIcon: Icons.lightbulb,
                  baseColor: HomsaiColors.primaryYellow,
                  title: "Lampada Tavolo",
                  room: "Camera",
                  info: "Dettagli",
                ),
                DashboardDevice(
                  DeviceStatus.group,
                  baseIcon: Icons.thermostat_rounded,
                  baseColor: HomsaiColors.primaryOrange,
                  title: "Clima Cucina",
                  room: "Cucina",
                  info: "22.3°",
                ),
              ]),
          SizedBox(height: 12)
        ],
      ),
    );
  }
}

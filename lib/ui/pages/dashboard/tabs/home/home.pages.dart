import 'package:flutter/material.dart';
import 'package:homsai/ui/widget/alert.widget.dart';
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
                text: "Potresti spegnere *Lampadario Salotto* alle 19."),
            action: AlertAction("Details", () {}),
          ),
          Alert(
            AlertType.warning,
            icon: const Icon(Icons.info_rounded),
            title: Text(
              "Miglioramento disponibile",
              style: Theme.of(context).textTheme.headline6,
            ),
            message: SuperRichText(
                text: "Potresti spegnere *Lampadario Salotto* alle 19."),
            action: AlertAction("Details", () {}),
          ),
          Alert(
            AlertType.error,
            icon: const Icon(Icons.info_rounded),
            title: Text(
              "Miglioramento disponibile",
              style: Theme.of(context).textTheme.headline6,
            ),
            message: SuperRichText(
                text: "Potresti spegnere *Lampadario Salotto* alle 19."),
            action: AlertAction("Details", () {}),
          ),
          Alert(
            AlertType.warning,
            icon: const Icon(Icons.info_rounded),
            title: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
            ),
          ),
          Alert(
            AlertType.error,
            icon: const Icon(Icons.info_rounded),
            title: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
              overflow: TextOverflow.clip,
            ),
          ),
          Alert(
            AlertType.info,
            icon: const Icon(Icons.info_rounded),
            title: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
            ),
            cancelable: false,
          ),
          Alert(
            AlertType.error,
            icon: const Icon(Icons.info_rounded),
            title: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
              overflow: TextOverflow.clip,
            ),
          ),
          Alert(
            AlertType.error,
            icon: const Icon(Icons.info_rounded),
            title: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
              overflow: TextOverflow.clip,
            ),
          ),
          Alert(
            AlertType.error,
            icon: const Icon(Icons.info_rounded),
            title: SuperRichText(
              text: "Potresti spegnere *Lampadario Salotto* alle 19.",
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}

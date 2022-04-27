import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:homsai/app.router.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _EmailButton(),
        _LocalUrlButton(),
        _RemoteUrlButton(),
        _ProductionSensorButton(),
        _ConsumptionSensorButton(),
        const _NameButton(),
        const _PositionButton(),
        const _VersionButton(),
        const SizedBox(height: 16),
        _ChangePlantButton(),
      ],
    );
  }
}

class _EmailButton extends _AccountButton {
  const _EmailButton()
      : super(
          title: 'Email',
          caption: 'mariorossi00@mail.com',
          onTap: null,
        );
}

class _LocalUrlButton extends _AccountButton {
  _LocalUrlButton()
      : super(
          title: 'URL Locale',
          caption: 'http://:192.168.x.x:8123',
          onTap: (context) => context.router.push(const UrlUpdateRoute()),
        );
}

class _RemoteUrlButton extends _AccountButton {
  _RemoteUrlButton()
      : super(
          title: 'URL Remoto',
          caption: 'http://:192.168.x.x:8123',
          onTap: (context) => context.router.push(const UrlUpdateRoute()),
        );
}

class _ProductionSensorButton extends _AccountButton {
  _ProductionSensorButton()
      : super(
          title: 'Sensore di produzione',
          caption: '[xxx]',
          onTap: (context) => context.router
              .push(AddSensorRoute(onResult: (_) => context.router.pop())),
        );
}

class _ConsumptionSensorButton extends _AccountButton {
  _ConsumptionSensorButton()
      : super(
          title: 'Sensore di consumo',
          caption: '[xxx]',
          onTap: (context) => context.router
              .push(AddSensorRoute(onResult: (_) => context.router.pop())),
        );
}

class _NameButton extends _AccountButton {
  const _NameButton()
      : super(
          title: 'Nome Impianto',
          caption: 'Casa Andrea',
          onTap: null,
        );
}

class _PositionButton extends _AccountButton {
  const _PositionButton()
      : super(
          title: 'Posizione Impianto',
          caption: 'Via Verdi, 165 - Roma - Italy',
          onTap: null,
        );
}

class _VersionButton extends _AccountButton {
  const _VersionButton()
      : super(
          title: 'Versione App',
          caption: '1.0',
          onTap: null,
        );
}

abstract class _AccountButton extends StatelessWidget {
  final String title;
  final String caption;
  final Function(BuildContext)? onTap;

  const _AccountButton({
    required this.title,
    required this.caption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap != null ? onTap!(context) : null,
      child: Row(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  caption,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePlantButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => print("ChangePlant"),
      child: const AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: Text(
          "Cambia impianto",
        ),
      ),
    );
  }
}

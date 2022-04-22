import 'package:flutter/material.dart';

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
        const _AccountButton(_AccountButtonType.email),
        const _AccountButton(_AccountButtonType.url),
        const _AccountButton(_AccountButtonType.sensor),
        const _AccountButton(_AccountButtonType.name),
        const _AccountButton(_AccountButtonType.position),
        const _AccountButton(_AccountButtonType.version),
        _ChangePlantButton(),
      ],
    );
  }
}

enum _AccountButtonType {
  email,
  url,
  sensor,
  name,
  position,
  version,
}

class _AccountButton extends StatelessWidget {
  final _AccountButtonType type;

  const _AccountButton(this.type);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print("Tap: ${_getTitle(type)} ${_getCaption(type)}"),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(type),
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  _getCaption(type),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(_AccountButtonType type) {
    switch (type) {
      case _AccountButtonType.email:
        return "Email";
      case _AccountButtonType.url:
        return "URL Istanza";
      case _AccountButtonType.sensor:
        return "Sensori";
      case _AccountButtonType.name:
        return "Nome Impianto";
      case _AccountButtonType.position:
        return "Posizione Impianto";
      case _AccountButtonType.version:
        return "Versione App";
    }
  }

  String _getCaption(_AccountButtonType type) {
    switch (type) {
      case _AccountButtonType.email:
        return "mariorossi00@mail.com";
      case _AccountButtonType.url:
        return "Local: http://:192.168.x.x:8123 Remote: ";
      case _AccountButtonType.sensor:
        return "[xxx] - [xxx]";
      case _AccountButtonType.name:
        return "Casa Andrea";
      case _AccountButtonType.position:
        return "Via Verdi, 165 - Roma - Italy";
      case _AccountButtonType.version:
        return "1.0";
    }
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

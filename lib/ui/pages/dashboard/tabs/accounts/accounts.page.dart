import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/crossconcern/components/utils/open_url.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.util.dart';
import 'package:homsai/ui/pages/dashboard/tabs/accounts/bloc/accounts.bloc.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<AccountsBloc>(
          create: (BuildContext context) => AccountsBloc(),
        ),
      ],
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          HomsaiLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      child: const _AccountsPage(),
    );
  }
}

class _AccountsPage extends StatefulWidget {
  const _AccountsPage({Key? key}) : super(key: key);

  @override
  State<_AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<_AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LocalUrlButton(),
        _RemoteUrlButton(),
        _ProductionSensorButton(),
        _ConsumptionSensorButton(),
        _BatterySensorButton(),
        _NameButton(),
        _PositionButton(),
        _EmailButton(),
        _VersionButton(),
        _BugReportButton()
      ],
    );
  }
}

class _EmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountEmail,
          caption: state.email ?? '-',
          onTap: null,
        );
      },
    );
  }
}

class _LocalUrlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountLocalUrl,
          caption: state.localUrl ?? '-',
          onTap: (context) => context.router.push(UrlUpdateRoute(
            onResult: (_) {
              context.router.pop();
              context.read<AccountsBloc>().add(WebsocketUpdate());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _RemoteUrlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountRemoteUrl,
          caption: state.remoteUrl ?? '-',
          onTap: (context) => context.router.push(UrlUpdateRoute(
            onResult: (_) {
              context.router.pop();
              context.read<AccountsBloc>().add(WebsocketUpdate());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _ProductionSensorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountProductionSensor,
          caption: state.productionSensor ?? '-',
          onTap: (context) => context.router.push(AddSensorRoute(
            onResult: (_) async {
              await context.router.pop();
              context.read<AccountsBloc>().add(SensorUpdate());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _ConsumptionSensorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountConsumptionSensor,
          caption: state.consumptionSensor ?? '-',
          onTap: (context) => context.router.push(AddSensorRoute(
            onResult: (_) async {
              await context.router.pop();
              context.read<AccountsBloc>().add(SensorUpdate());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _BatterySensorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountBatterySensor,
          caption: state.batterySensor ?? '-',
          onTap: (context) => context.router.push(AddSensorRoute(
            onResult: (_) async {
              await context.router.pop();
              context.read<AccountsBloc>().add(SensorUpdate());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _NameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountPlantName,
          caption: state.plantName ?? '-',
          onTap: (context) => context.router.push(AddPlantRoute(
            onResult: (_) {
              context.router.pop();
              context.read<AccountsBloc>().add(Update());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _PositionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountPosition,
          caption: state.position ?? '-',
          onTap: (context) => context.router.push(AddPlantRoute(
            onResult: (_) {
              context.router.pop();
              context.read<AccountsBloc>().add(Update());
            },
            wizard: false,
          )),
        );
      },
    );
  }
}

class _VersionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountVersion,
          caption: state.version ?? '-',
          onTap: null,
        );
      },
    );
  }
}

class _BugReportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: HomsaiLocalizations.of(context)!.accountBugReportTitle,
          caption: HomsaiLocalizations.of(context)!.accountBugReportCaption,
          onTap: (context) => openUrl(context, bugReportUrl),
        );
      },
    );
  }
}

class _AccountButton extends StatelessWidget {
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
    final titleTheme = Theme.of(context).textTheme.headline4;
    final captionTheme = Theme.of(context).textTheme.caption;
    return InkWell(
      onTap: () => onTap != null ? onTap!(context) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: onTap != null
                      ? titleTheme
                      : titleTheme?.copyWith(
                          color: titleTheme.color?.withOpacity(0.5)),
                ),
                Text(
                  caption,
                  style: onTap != null
                      ? captionTheme
                      : captionTheme?.copyWith(
                          color: captionTheme.color?.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/app.router.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/themes/colors.theme.dart';
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

class _AccountsPage extends StatelessWidget {
  const _AccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LocalUrlButton(),
        _RemoteUrlButton(),
        _ProductionSensorButton(),
        _ConsumptionSensorButton(),
        _NameButton(),
        _PositionButton(),
        _EmailButton(),
        _VersionButton(),
        /*const SizedBox(height: 16),
        _ChangePlantButton(),*/
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
          title: 'Email',
          caption: state.email ?? 'mariorossi00@mail.com',
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
          title: 'URL Locale',
          caption: state.localUrl ?? 'http[s]://x.x.x.x[:8123]',
          onTap: (context) => context.router.push(UrlUpdateRoute(
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

class _RemoteUrlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: 'URL Remoto',
          caption: state.remoteUrl ?? 'http[s]://x.x.x.x[:8123]',
          onTap: (context) => context.router.push(UrlUpdateRoute(
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

class _ProductionSensorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: 'Sensore di produzione',
          caption: state.productionSensor ?? '[xxx]',
          onTap: (context) => context.router.push(AddSensorRoute(
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

class _ConsumptionSensorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: 'Sensore di consumo',
          caption: state.consumptionSensor ?? '[xxx]',
          onTap: (context) => context.router.push(AddSensorRoute(
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

class _NameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        return _AccountButton(
          title: 'Nome Impianto',
          caption: state.plantName ?? 'Casa',
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
          title: 'Posizione Impianto',
          caption: state.position ?? '0.00000, 0.00000',
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
          title: 'Versione App',
          caption: state.version ?? '0.0',
          onTap: null,
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

class _ChangePlantButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      //TODO: add logic -> scanner
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

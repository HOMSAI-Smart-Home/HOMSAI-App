import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/ui/pages/add_plant/bloc/add_plant.bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

class AddPlantPage extends StatefulWidget {
  final void Function(bool) onResult;

  const AddPlantPage({Key? key, required this.onResult}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<WebSocketBloc>(create: (_) => WebSocketBloc()),
        BlocProvider<AddPlantBloc>(
          create: (context) => AddPlantBloc(context.read<WebSocketBloc>()),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _AddPlantTitle(),
        _AddPlantForm(),
        const SizedBox(height: 24),
        _AddPlantSubmit(widget.onResult),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _AddPlantTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          HomsaiLocalizations.of(context)!.addPlantTitle,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _AddPlantForm extends StatefulWidget {
  @override
  State<_AddPlantForm> createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<_AddPlantForm> {
  @override
  void initState() {
    context.read<WebSocketBloc>().add(FetchConfig(
      onConfigurationFetched: (config) {
        context.read<AddPlantBloc>().add(ConfigurationFetched(config));
        context.read<WebSocketBloc>().add(FetchEntites(
              onEntitiesFetched: (entities) =>
                  context.read<AddPlantBloc>().add(StatesFetched(entities)),
            ));
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _AddPlantNameField(),
        const SizedBox(
          height: 24,
        ),
        _AddPlantLocationField()
      ],
    );
  }
}

class _AddPlantNameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPlantBloc, AddPlantState>(
        buildWhen: (previous, current) =>
            previous.plantName != current.plantName ||
            previous.initialPlantName != current.initialPlantName,
        builder: ((context, state) {
          return TextFormField(
            key: ValueKey(
              state.initialPlantName,
            ),
            restorationId: 'plant_name_text_field',
            keyboardType: TextInputType.name,
            onChanged: (value) {
              context.read<AddPlantBloc>().add(PlantNameChanged(value));
            },
            initialValue: state.initialPlantName,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.house_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              labelText: HomsaiLocalizations.of(context)!.addPlantNameLabel,
            ),
            style: Theme.of(context).textTheme.bodyText1,
          );
        }));
  }
}

class _AddPlantLocationField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AddPlantBloc, AddPlantState>(builder: ((context, state) {
          return TextFormField(
            key: ValueKey(
              state.coordinate.value,
            ),
            restorationId: 'coordinate_text_field',
            onChanged: (value) {
              context.read<AddPlantBloc>().add(CoordinateChanged(value));
            },
            enabled: false,
            initialValue: state.coordinate.value,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.place_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              labelText: HomsaiLocalizations.of(context)!.addPlantLocationLabel,
            ),
            style: Theme.of(context).textTheme.bodyText2,
          );
        })),
        /*
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            HomsaiLocalizations.of(context)!.addPlantLocationButtonLabel,
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        */
        const SizedBox(height: 16),
        _AddPlantLocationInfo()
      ],
    );
  }
}

class _AddPlantLocationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HomsaiLocalizations.of(context)!.addPlantLocationInfoTitle,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 6),
        Text(
          HomsaiLocalizations.of(context)!.addPlantLocationInfoDescription,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}

class _AddPlantSubmit extends StatelessWidget {
  final void Function(bool) onResult;

  const _AddPlantSubmit(this.onResult);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AddPlantBloc>().add(OnSubmit(
              () => context.router.push(AddSensorRoute(onResult: onResult)),
            ));
      },
      child: Text(HomsaiLocalizations.of(context)!.next),
    );
  }
}

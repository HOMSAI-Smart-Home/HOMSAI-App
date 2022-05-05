import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/dropdown.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/ui/pages/add_sensor/bloc/add_sensor.bloc.dart';

import '../../../crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';

class AddSensorPage extends StatefulWidget {
  final void Function(bool) onResult;
  final bool wizard;

  const AddSensorPage({
    Key? key,
    required this.onResult,
    this.wizard = true,
  }) : super(key: key);

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<WebSocketBloc>(
          create: (_) => WebSocketBloc(),
        ),
        BlocProvider<AddSensorBloc>(
          create: (context) => AddSensorBloc(context.read<WebSocketBloc>()),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _AddSensorTitle(widget.wizard),
        _ProductionSensorsSelect(),
        const SizedBox(
          height: 24,
        ),
        _ConsumptionSensorsSelect(),
        const SizedBox(
          height: 24,
        ),
        _AddSensorSubmit(widget.onResult, widget.wizard)
      ],
    );
  }
}

class _AddSensorTitle extends StatelessWidget {
  final bool wizard;

  const _AddSensorTitle(this.wizard);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(wizard
          ? HomsaiLocalizations.of(context)!.addPlantTitleWizard
          : HomsaiLocalizations.of(context)!.addPlantTitleEdit,
            style: Theme.of(context).textTheme.headline3),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _ProductionSensorsSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSensorBloc, AddSensorState>(
        builder: (context, state) {
      return HomsaiDropdownButton<MesurableSensorEntity>(
        label: "Produzione",
        hint: "Nome Sensore di produzione",
        value: state.selectedProductionSensor,
        items: state.productionSensors
            .map(
              (sensor) => DropdownMenuItem<MesurableSensorEntity>(
                child: Text(sensor.name),
                value: sensor,
              ),
            )
            .toList(),
        onChanged: (sensor) =>
            context.read<AddSensorBloc>().add(ProductionSensorChanged(sensor)),
      );
    });
  }
}

class _ConsumptionSensorsSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSensorBloc, AddSensorState>(
        builder: (context, state) {
      return HomsaiDropdownButton<MesurableSensorEntity>(
        label: "Consumo",
        hint: "Nome Sensore di consumo",
        value: state.selectedConsumptionSensor,
        items: state.consumptionSensors
            .map(
              (sensor) => DropdownMenuItem<MesurableSensorEntity>(
                child: Text(sensor.name),
                value: sensor,
              ),
            )
            .toList(),
        onChanged: (sensor) =>
            context.read<AddSensorBloc>().add(ConsumptionSensorChanged(sensor)),
      );
    });
  }
}

class _AddSensorSubmit extends StatelessWidget {
  final void Function(bool) onResult;
  final bool wizard;

  const _AddSensorSubmit(this.onResult, this.wizard);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => wizard
          ? context.read<AddSensorBloc>().add(OnSubmit(
                () => onResult(true),
              ))
          : onResult(true),
      child: Text(HomsaiLocalizations.of(context)!.next),
    );
  }
}

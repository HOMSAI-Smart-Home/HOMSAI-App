import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/dropdown.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/add_sensor/bloc/add_sensor.bloc.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/home.page.dart';

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
        _AddPlantDescription(widget.wizard),
        _ProductionSensorsSelect(),
        const SizedBox(
          height: 9,
        ),
        _ConsumptionSensorsSelect(),
        const SizedBox(
          height: 16,
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
        Text(
          wizard
              ? HomsaiLocalizations.of(context)!.addSensorTitleWizard
              : HomsaiLocalizations.of(context)!.addPlantTitleEdit,
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class _AddPlantDescription extends StatelessWidget {
  final bool wizard;

  const _AddPlantDescription(this.wizard);

  @override
  Widget build(BuildContext context) {
    return Text(
      wizard
          ? HomsaiLocalizations.of(context)!.addPlantDescriptionWizard
          : HomsaiLocalizations.of(context)!.addPlantDescriptionEdit,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}

class _ProductionSensorsSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSensorBloc, AddSensorState>(
        builder: (context, state) {
      return HomsaiDropdownButton<MesurableSensorEntity>(
        label: HomsaiLocalizations.of(context)!.productionSensorLabel,
        hint: HomsaiLocalizations.of(context)!.productionSensorHint,
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
        label: HomsaiLocalizations.of(context)!.consumptionSensorLabel,
        hint: HomsaiLocalizations.of(context)!.consumptionSensorHint,
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
    return BlocBuilder<AddSensorBloc, AddSensorState>(
        builder: (context, state) {
      return ElevatedButton(
        onPressed: () {
          checkSensorsSelection(context, state);
        },
        child: Text(HomsaiLocalizations.of(context)!.next),
      );
    });
  }

  void checkSensorsSelection(BuildContext context, AddSensorState state) {
    final bloc = context.read<AddSensorBloc>();
    Map<String, MesurableSensorEntity?> selectedSensor = {
      HomsaiLocalizations.of(context)!.productionSensorLabel:
          state.selectedProductionSensor,
      HomsaiLocalizations.of(context)!.consumptionSensorLabel:
          state.selectedConsumptionSensor,
    };
    if (selectedSensor.containsValue(null)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(HomsaiLocalizations.of(context)!
                        .consumptionSensorPopUpContent1),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(HomsaiLocalizations.of(context)!
                        .consumptionSensorPopUpContent2),
                    ...getIncompleteSensors(selectedSensor, context),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                scrollable: true,
                insetPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 24.0),
                titlePadding: const EdgeInsets.only(
                    top: 10, left: 20, right: 10, bottom: 0),
                contentPadding: const EdgeInsets.only(
                    top: 25, left: 20, right: 10, bottom: 0),
                title: Row(
                  children: [
                    Text(
                      HomsaiLocalizations.of(context)!
                          .consumptionSensorPopUpTitle,
                      style: TextStyle(color: HomsaiColors.primaryWhite),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () =>
                              {bloc.add(OnSubmit(() => onResult(true)))},
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  HomsaiLocalizations.of(context)!
                                      .consumptionSensorPopUpIgnore,
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  HomsaiLocalizations.of(context)!
                                      .consumptionSensorPopUpModify,
                                  style: TextStyle(
                                      color: HomsaiColors.primaryGreen),
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  )
                ],
              ));
    } else {
      bloc.add(OnSubmit(() => onResult(true)));
    }
  }

  List<Widget> getIncompleteSensors(
      Map<String, MesurableSensorEntity?> selectedSensor,
      BuildContext context) {
    List<String> keys = selectedSensor.keys.toList();
    List<Widget> incompleteFieldsTexts = [];
    for (var key in keys) {
      if (selectedSensor[key] == null) {
        incompleteFieldsTexts.add(Padding(
          padding: const EdgeInsets.only(top: 10, right: 0, left: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5, right: 10, left: 10),
                child: Bullet(),
              ),
              Text(key, style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
        ));
      }
    }
    return incompleteFieldsTexts;
  }
}

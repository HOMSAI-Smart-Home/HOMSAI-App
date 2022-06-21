import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homsai/crossconcern/components/common/dropdown.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/crossconcern/components/utils/bullet.widget.dart';
import 'package:homsai/crossconcern/components/utils/month_year_field/bloc/month_year_field.bloc.dart';
import 'package:homsai/crossconcern/components/utils/month_year_field/month_year_field.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/add_sensor/bloc/add_sensor.bloc.dart';

class AddSensorPage extends StatefulWidget {
  final void Function(bool) onResult;
  final Uri? url;
  final bool wizard;

  const AddSensorPage({
    Key? key,
    required this.onResult,
    this.wizard = true,
    this.url,
  }) : super(key: key);

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<AddSensorBloc>(
          create: (context) =>
              AddSensorBloc(context.read<WebSocketBloc>(), widget.url),
        ),
        BlocProvider<MonthYearFieldBloc>(
          create: (context) => MonthYearFieldBloc(),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _AddSensorTitle(widget.wizard),
        _AddPlantDescription(widget.wizard),
        const SizedBox(
          height: 8,
        ),
        _ConsumptionSensorsSelect(),
        const SizedBox(
          height: 8,
        ),
        _ProductionSensorsSelect(),
        const SizedBox(
          height: 8,
        ),
        _BatterySensorsSelect(),
        const SizedBox(
          height: 16,
        ),
        _PhotovoltaicNominalPower(),
        const SizedBox(
          height: 16,
        ),
        _PhotovoltaicInstallationDate(),
        const SizedBox(
          height: 16,
        ),
        _AddSensorSubmit(widget.onResult, widget.wizard),
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
                value: sensor,
                child: Text(sensor.name),
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
                value: sensor,
                child: Text(sensor.name),
              ),
            )
            .toList(),
        onChanged: (sensor) =>
            context.read<AddSensorBloc>().add(ConsumptionSensorChanged(sensor)),
      );
    });
  }
}

class _PhotovoltaicNominalPower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSensorBloc, AddSensorState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.initialPhotovoltaicNominalPower,
          key: ValueKey(state.initialPhotovoltaicNominalPower),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            _PhotovoltaicNominalPowerFormatter(),
          ],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                "assets/icons/power.svg",
              ),
            ),
            labelText:
                '${HomsaiLocalizations.of(context)!.photovoltaicNominalPowerLabel} ('
                '${HomsaiLocalizations.of(context)!.photovoltaicNominalPowerUnitOfMeasure})',
          ),
          onChanged: (value) {
            context.read<AddSensorBloc>().add(
                  PhotovoltaicNominalPowerChanged(value),
                );
          },
          style: Theme.of(context).textTheme.bodyText1,
        );
      },
    );
  }
}

class _PhotovoltaicNominalPowerFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final stringCheck = RegExp(r'^(\d+(,|\.){0,1}\d*){0,1}$');
    return stringCheck.hasMatch(newValue.text) ? newValue : oldValue;
  }
}

class _PhotovoltaicInstallationDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSensorBloc, AddSensorState>(
        builder: (context, state) {
      return MonthYearField(
        labelText:
            HomsaiLocalizations.of(context)!.photovoltaicInstallationDate,
        initialValue: state.initialPhotovoltaicInstallationDate,
        onChanged: (value) {
          context
              .read<AddSensorBloc>()
              .add(PhotovoltaicInstallatioDateChanged(value));
        },
      );
    });
  }
}

class _BatterySensorsSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSensorBloc, AddSensorState>(
        builder: (context, state) {
      return HomsaiDropdownButton<MesurableSensorEntity>(
        label: HomsaiLocalizations.of(context)!.batterySensorLabel,
        hint: HomsaiLocalizations.of(context)!.batterySensorHint,
        value: state.selectedBatterySensor,
        items: state.batterySensors
            .map(
              (sensor) => DropdownMenuItem<MesurableSensorEntity>(
                value: sensor,
                child: Text(sensor.name),
              ),
            )
            .toList(),
        onChanged: (sensor) =>
            context.read<AddSensorBloc>().add(BatterySensorChanged(sensor)),
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
    Map<String, bool?> selectedSensor = {
      HomsaiLocalizations.of(context)!.productionSensorLabel:
          state.selectedProductionSensor != null ? true : false,
      HomsaiLocalizations.of(context)!.consumptionSensorLabel:
          state.selectedConsumptionSensor != null ? true : false,
      HomsaiLocalizations.of(context)!.photovoltaicNominalPowerLabel:
          state.photovoltaicNominalPower == "" ? false : true,
      HomsaiLocalizations.of(context)!.photovoltaicInstallationDate:
          state.photovoltaicInstallationDate != null ? true : false,
    };
    if (selectedSensor.containsValue(false)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(HomsaiLocalizations.of(context)!
                        .addSensorPopUpContent1),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(HomsaiLocalizations.of(context)!
                        .addSensorPopUpContent2),
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
                      HomsaiLocalizations.of(context)!.addSensorPopUpTitle,
                      style: const TextStyle(color: HomsaiColors.primaryWhite),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () =>
                              {bloc.add(OnSubmit(() => onResult(true)))},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  HomsaiLocalizations.of(context)!
                                      .addSensorPopUpIgnore,
                                ),
                              ),
                            ],
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  HomsaiLocalizations.of(context)!
                                      .addSensorPopUpModify,
                                  style: const TextStyle(
                                      color: HomsaiColors.primaryGreen),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
    } else {
      bloc.add(OnSubmit(() => onResult(true)));
    }
  }

  List<Widget> getIncompleteSensors(
      Map<String, bool?> selectedSensor, BuildContext context) {
    List<String> keys = selectedSensor.keys.toList();
    List<Widget> incompleteFieldsTexts = [];
    for (var key in keys) {
      if (selectedSensor[key] == false) {
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

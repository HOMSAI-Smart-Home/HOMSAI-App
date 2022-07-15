import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/ui/widget/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/ui/widget/utils/trimmed_text_form_field.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/add_plant/bloc/add_plant.bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

class AddPlantPage extends StatefulWidget {
  final void Function(bool) onResult;
  final String? localUrl;
  final String? remoteUrl;
  final bool wizard;

  const AddPlantPage({
    Key? key,
    required this.onResult,
    this.localUrl,
    this.remoteUrl,
    this.wizard = true,
  }) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<AddPlantBloc>(
          create: (context) => AddPlantBloc(
            context.read<WebSocketBloc>(),
            widget.wizard
                ? widget.localUrl!.isNotEmpty
                    ? widget.localUrl
                    : widget.remoteUrl
                : null,
            (widget.wizard && widget.localUrl!.isNotEmpty)
                ? widget.remoteUrl
                : null,
            widget.wizard,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _AddPlantTitle(widget.wizard),
        _AddPlantForm(),
        const SizedBox(height: 24),
        _AddPlantSubmit(
          widget.onResult,
          widget.wizard,
          widget.localUrl,
          widget.remoteUrl,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _AddPlantTitle extends StatelessWidget {
  final bool wizard;

  const _AddPlantTitle(this.wizard);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          wizard
              ? HomsaiLocalizations.of(context)!.addPlantTitleWizard
              : HomsaiLocalizations.of(context)!.addPlantTitleEdit,
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
          return TrimmedTextFormField(
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
              prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: SvgPicture.asset(
                    "assets/icons/home.svg",
                  )),
              errorText: state.status.isInvalid
                  ? HomsaiLocalizations.of(context)!.invalidPlantName
                  : null,
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
          return TrimmedTextFormField(
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
              prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: SvgPicture.asset(
                    "assets/icons/place.svg",
                    color: HomsaiColors.primaryGrey,
                  )),
              labelText: HomsaiLocalizations.of(context)!.addPlantLocationLabel,
            ),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: HomsaiColors.primaryGrey),
          );
        })),
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
  final String? localUrl;
  final String? remoteUrl;
  final bool wizard;

  const _AddPlantSubmit(
    this.onResult,
    this.wizard,
    this.localUrl,
    this.remoteUrl,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPlantBloc, AddPlantState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => ElevatedButton(
        onPressed: state.status.isValid
            ? () => context.read<AddPlantBloc>().add(
                  OnSubmit(
                    () => wizard
                        ? context.router
                            .push(AddSensorRoute(onResult: onResult))
                        : onResult(true),
                    localUrl ?? '',
                    remoteUrl ?? '',
                  ),
                )
            : null,
        child: Text(HomsaiLocalizations.of(context)!.next),
      ),
    );
  }
}

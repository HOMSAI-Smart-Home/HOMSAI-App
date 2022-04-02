import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/ui/pages/add_plant/bloc/add_plant.bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:auto_route/auto_route.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({Key? key}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<AddPlantBloc>(
          create: (BuildContext context) => AddPlantBloc(),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _AddPlantTitle(),
        _AddPlantForm(),
        const SizedBox(height: 24),
        _AddPlantSubmit(),
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
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _AddPlantForm extends StatelessWidget {
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
    return TextFormField(
      restorationId: 'implant_name_text_field',
      keyboardType: TextInputType.name,
      onChanged: (value) {},
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.house_rounded,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        labelText: HomsaiLocalizations.of(context)!.addPlantNameLabel,
      ),
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

class _AddPlantLocationField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          restorationId: 'coordinate_text_field',
          keyboardType: TextInputType.name,
          onChanged: (value) {},
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.place_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            labelText: HomsaiLocalizations.of(context)!.addPlantLocationLabel,
          ),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            HomsaiLocalizations.of(context)!.addPlantLocationButtonLabel,
          ),
        ),
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
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 6),
        Text(
          HomsaiLocalizations.of(context)!.addPlantLocationInfoDescription,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}

class _AddPlantSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.router.push(const DashboardRoute());
      },
      child: Text(HomsaiLocalizations.of(context)!.next),
    );
  }
}

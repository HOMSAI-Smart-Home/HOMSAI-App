import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/ui/pages/intro_beta/bloc/intro_beta.bloc.dart';

class IntroBetaPage extends StatefulWidget {
  final void Function(bool) onResult;

  const IntroBetaPage({Key? key, required this.onResult}) : super(key: key);

  @override
  State<IntroBetaPage> createState() => _IntroBetaPageState();
}

class _IntroBetaPageState extends State<IntroBetaPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<IntroBetaBloc>(
          create: (_) => IntroBetaBloc(),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _IntroBetaTitle(),
        _IntroBetaDescription(),
        const SizedBox(height: 24),
        _IntroBetaForm(),
        const SizedBox(height: 24),
        _IntroBetaSubmit(widget.onResult),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _IntroBetaTitle extends StatelessWidget {
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

class _IntroBetaDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          HomsaiLocalizations.of(context)!.emailDescription,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _IntroBetaForm extends StatefulWidget {
  @override
  State<_IntroBetaForm> createState() => _IntroBetaFormState();
}

class _IntroBetaFormState extends State<_IntroBetaForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[_EmailAddressTextField()],
    );
  }
}

class _EmailAddressTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
        builder: (context, state) {
      return TextFormField(
        key: ValueKey(
          state.email.value,
        ),
        restorationId: 'emailaddress_text_field',
        initialValue: state.email.value,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          context.read<IntroBetaBloc>().add(EmailChanged(email: value));
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email_rounded,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          labelText: HomsaiLocalizations.of(context)!.emailAddress,
          errorText: state.email.invalid
              ? HomsaiLocalizations.of(context)!.invalidEmail
              : null,
        ),
        style: Theme.of(context).textTheme.bodyText1,
      );
    });
  }
}

class _IntroBetaSubmit extends StatelessWidget {
  final void Function(bool) onResult;

  const _IntroBetaSubmit(this.onResult);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: (state.status.isValid)
                ? () => context
                    .read<IntroBetaBloc>()
                    .add(OnSubmit(() => onResult(true)))
                : null,
            child: Text(HomsaiLocalizations.of(context)!.next),
          );
        });
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/app.router.dart';
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
          style: Theme.of(context)
              .textTheme
              .bodyText1,
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
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<IntroBetaBloc>().add(EmailUnfocused());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[_EmailAddressTextField(focusNode: _emailFocusNode)],
    );
  }
}

class _EmailAddressTextField extends StatelessWidget {
  const _EmailAddressTextField({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
        builder: (context, state) {
      return TextFormField(
        restorationId: 'emailaddress_text_field',
        focusNode: focusNode,
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
            onPressed: state.status.isValid
                ? () => onResult(true)
                : null,
            child: Text(HomsaiLocalizations.of(context)!.next),
          );
        });
  }
}

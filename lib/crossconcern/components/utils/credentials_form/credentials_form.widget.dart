import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/components/utils/checkbox_text.widget.dart';
import 'package:homsai/crossconcern/components/utils/credentials_form/bloc/credentials_form.bloc.dart';
import 'package:homsai/crossconcern/components/utils/textfield.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

class CredentialsForm extends StatelessWidget {
  final bool hasAgreeement;
  final String? submitLabel;

  const CredentialsForm(
      {Key? key, required this.submitLabel, this.hasAgreeement = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CredentialsFormBloc(),
      child: _CredentialsForm(
        submitLabel: submitLabel,
        hasAgreeement: hasAgreeement,
      ),
    );
  }
}

class _CredentialsForm extends StatefulWidget {
  final bool hasAgreeement;
  final String? submitLabel;

  const _CredentialsForm(
      {Key? key, required this.submitLabel, this.hasAgreeement = false})
      : super(key: key);

  @override
  _CredentialsFormState createState() => _CredentialsFormState();
}

class _CredentialsFormState extends State<_CredentialsForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<CredentialsFormBloc>().add(EmailUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<CredentialsFormBloc>().add(PasswordUnfocused());
      }
    });

    if (widget.hasAgreeement) {
      BlocProvider.of<CredentialsFormBloc>(context)
          .add(const AgreementChanged(agreement: false));
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CredentialsFormBloc, CredentialsFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Column(
        children: <Widget>[
          EmailAddressTextField(focusNode: _emailFocusNode),
          const SizedBox(
            height: 16,
          ),
          PasswordTextField(focusNode: _passwordFocusNode),
          const SizedBox(
            height: 16,
          ),
          if (widget.hasAgreeement)
            Column(
              children: <Widget>[
                CheckboxText(
                  onChanged: (isChecked) {
                    context
                        .read<CredentialsFormBloc>()
                        .add(AgreementChanged(agreement: isChecked!));
                  },
                  child: Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.subtitle2,
                        children: <TextSpan>[
                          TextSpan(
                            text: HomsaiLocalizations.of(context)!
                                .termsAgreements1,
                          ),
                          TextSpan(
                            text: HomsaiLocalizations.of(context)!
                                .termsAgreements2,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          const SizedBox(
            height: 16,
          ),
          SubmitButton(
            label: widget.submitLabel,
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String? label;

  const SubmitButton({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialsFormBloc, CredentialsFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status.isValid
              ? () => context.read<CredentialsFormBloc>().add(FormSubmitted())
              : null,
          child: state.status.isSubmissionInProgress
              ? Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                )
              : Text(label ?? ""),
        );
      },
    );
  }
}

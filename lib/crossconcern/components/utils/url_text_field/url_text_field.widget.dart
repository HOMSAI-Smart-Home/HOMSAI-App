import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';

class UrlTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final String? errorText;
  final String? labelText;

  const UrlTextField({
    Key? key,
    this.focusNode,
    this.errorText,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UrlTextFieldBloc(),
      child: _UrlTextField(
        focusNode: focusNode ?? FocusNode(),
        errorText: errorText,
        labelText: labelText,
      ),
    );
  }
}

class _UrlTextField extends StatelessWidget {
  final FocusNode focusNode;
  final String? errorText;
  final String? labelText;

  const _UrlTextField({
    Key? key,
    required this.focusNode,
    this.errorText,
    this.labelText,
  }) : super(key: key);

  Color _color(BuildContext context, UrlTextFieldState state) {
    return (state.status == FormzStatus.invalid)
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onBackground;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlTextFieldBloc, UrlTextFieldState>(
        buildWhen: (previous, current) =>
            previous.initialUrl.value != current.initialUrl.value ||
            previous.status != current.status,
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                key: ValueKey(state.initialUrl.value),
                initialValue: state.initialUrl.value,
                focusNode: focusNode,
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  context.read<UrlTextFieldBloc>().add(UrlChanged(url: value));
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.link, color: _color(context, state)),
                  errorText: state.status.isInvalid
                      ? errorText ??
                          HomsaiLocalizations.of(context)!
                              .homeAssistantScanManualError
                      : null,
                  labelText:
                      labelText ?? HomsaiLocalizations.of(context)!.urlLabel,
                ),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ));
        });
  }
}

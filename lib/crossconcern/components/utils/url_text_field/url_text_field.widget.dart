import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';

class UrlTextField<Bloc extends UrlTextFieldBloc> extends StatelessWidget {
  final FocusNode? focusNode;
  final String? errorText;
  final String? labelText;
  final TextInputAction? textInputAction;
  final Function(String)? onChange;

  const UrlTextField({
    Key? key,
    this.focusNode,
    this.errorText,
    this.labelText,
    this.textInputAction,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _UrlTextField<Bloc>(
      focusNode: focusNode ?? FocusNode(),
      errorText: errorText,
      labelText: labelText,
      textInputAction: textInputAction,
      onChange: onChange,
    );
  }
}

class _UrlTextField<Bloc extends UrlTextFieldBloc> extends StatelessWidget {
  final FocusNode focusNode;
  final String? errorText;
  final String? labelText;
  final TextInputAction? textInputAction;
  final Function(String)? onChange;

  const _UrlTextField(
      {Key? key,
      required this.focusNode,
      this.errorText,
      this.labelText,
      this.textInputAction,
      this.onChange})
      : super(key: key);

  Color _color(BuildContext context, UrlTextFieldState state) {
    return (state.status == FormzStatus.invalid)
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onBackground;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc, UrlTextFieldState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextFormField(
            key: ValueKey(state.initialUrl),
            initialValue: state.initialUrl,
            focusNode: focusNode,
            keyboardType: TextInputType.url,
            textInputAction: textInputAction,
            onChanged: onChange == null
                ? (value) => context.read<Bloc>().add(UrlChanged(url: value))
                : (value) => onChange!(value),
            decoration: InputDecoration(
              prefixIcon: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SvgPicture.asset(
                    "assets/icons/link.svg",
                  )),
              errorText: state.status != UrlTextFieldStatus.invalid
                  ? null
                  : errorText ??
                      HomsaiLocalizations.of(context)!
                          .homeAssistantScanManualError,
              labelText: labelText ?? HomsaiLocalizations.of(context)!.urlLabel,
            ),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        );
      },
    );
  }
}

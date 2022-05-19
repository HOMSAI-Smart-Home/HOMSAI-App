import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/month_year_field/bloc/month_year_field.bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MonthYearField<Bloc extends MonthYearFieldBloc> extends StatelessWidget {
  const MonthYearField({
    this.key,
    this.obscureText = false,
    this.enabled = true,
    required this.labelText,
  }) : super(key: key);

  final Key? key;
  final bool obscureText;
  final bool enabled;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return _MonthYearField<Bloc>(
      labelText: labelText,
      obscureText: obscureText,
      enabled: enabled,
    );
  }
}

class _MonthYearField<Bloc extends MonthYearFieldBloc> extends StatelessWidget {
  const _MonthYearField({
    this.key,
    this.obscureText = false,
    this.enabled = true,
    required this.labelText,
  }) : super(key: key);

  final Key? key;
  final bool obscureText;
  final bool enabled;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    return BlocBuilder<MonthYearFieldBloc, MonthYearFieldState>(
        builder: (context, state) {
      var startDate = HomsaiLocalizations.of(context)!
          .photovoltaicInstallationDateStartValue;
      focusNode.addListener(
        () {
          if (!focusNode.hasFocus && state.controller.text == startDate) {
            context.read<Bloc>().add(
                  FieldUnfocused(
                    startValue: HomsaiLocalizations.of(context)!
                        .photovoltaicInstallationDateStartValue,
                  ),
                );
          }
        },
      );
      return TextFormField(
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        controller: createController(state.controller),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              "assets/icons/calendar.svg",
            ),
          ),
          labelText: labelText,
        ),
        style: Theme.of(context).textTheme.bodyText1,
        focusNode: focusNode,
        onTap: () => context.read<Bloc>().add(
              FieldFocused(
                controllerText: HomsaiLocalizations.of(context)!
                    .photovoltaicInstallationDateStartValue,
              ),
            ),
        onChanged: (value) => context.read<Bloc>().add(
              FieldChanged(
                value: value,
                controller: state.controller,
                monthLetter: HomsaiLocalizations.of(context)!.monthLetter,
                yearLetter: HomsaiLocalizations.of(context)!.yearLetter,
              ),
            ),
        cursorWidth: 0.0,
        obscureText: obscureText,
        enabled: enabled,
      );
    });
  }

  TextEditingController createController(TextEditingValue controller) {
    print("createcontroller:");
    return TextEditingController.fromValue(controller);
  }
}

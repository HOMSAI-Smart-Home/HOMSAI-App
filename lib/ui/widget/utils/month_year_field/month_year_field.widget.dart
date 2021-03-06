import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/ui/widget/utils/month_year_field/bloc/month_year_field.bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/themes/colors.theme.dart';

class MonthYearField<Bloc extends MonthYearFieldBloc> extends StatelessWidget {
  const MonthYearField({
    Key? key,
    this.obscureText = false,
    this.enabled = true,
    required this.labelText,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final bool obscureText;
  final bool enabled;
  final String labelText;
  final Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return _MonthYearField<Bloc>(
      labelText: labelText,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      initialValue: initialValue,
    );
  }
}

class _MonthYearField<Bloc extends MonthYearFieldBloc> extends StatelessWidget {
  _MonthYearField({
    Key? key,
    this.obscureText = false,
    this.enabled = true,
    required this.labelText,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final bool obscureText;
  final bool enabled;
  final String labelText;
  final FocusNode focusNode = FocusNode();
  final Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    if (initialValue != null) {
      context.read<Bloc>().add(
            FieldValueChanged(
              valueChanged: initialValue!,
              selection: controller.selection,
            ),
          );
    }
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        validateTextField(controller.text, context);
        if (controller.text ==
            HomsaiLocalizations.of(context)!
                .photovoltaicInstallationDateStartValue) {
          controller.text = "";
        }
      }
    });

    return BlocBuilder<MonthYearFieldBloc, MonthYearFieldState>(
      builder: (context, state) {
        controller.text = state.valueChanged;
        controller.selection = state.selection;

        return TextFormField(
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                "assets/icons/calendar.svg",
              ),
            ),
            labelText: labelText,
            floatingLabelStyle: TextStyle(
                color: state.errorText != ""
                    ? HomsaiColors.primaryRed
                    : HomsaiColors.primaryWhite),
            errorText: state.errorText != "" ? state.errorText : null,
            errorStyle: const TextStyle(height: 1),
          ),
          style: Theme.of(context).textTheme.bodyText1,
          focusNode: focusNode,
          onTap: () {
            if (controller.text == "") {
              controller.text = HomsaiLocalizations.of(context)!
                  .photovoltaicInstallationDateStartValue;
            }
          },
          onChanged: (value) {
            value = value.replaceAll(RegExp(r"\D"), "");
            var yl = HomsaiLocalizations.of(context)!.yearLetter;
            var ml = HomsaiLocalizations.of(context)!.monthLetter;
            switch (value.length) {
              case 0:
                controller.text = "$ml$ml/$yl$yl$yl$yl";
                controller.selection = const TextSelection.collapsed(offset: 0);
                break;
              case 1:
                controller.text = "$value$ml/$yl$yl$yl$yl";
                controller.selection = const TextSelection.collapsed(offset: 1);
                break;
              case 2:
                controller.text = "$value/$yl$yl$yl$yl";
                controller.selection = const TextSelection.collapsed(offset: 2);
                break;
              case 3:
                controller.text =
                    "${value.substring(0, 2)}/${value.substring(2)}$yl$yl$yl";
                controller.selection = const TextSelection.collapsed(offset: 4);
                break;
              case 4:
                controller.text =
                    "${value.substring(0, 2)}/${value.substring(2, 4)}$yl$yl";
                controller.selection = const TextSelection.collapsed(offset: 5);
                break;
              case 5:
                controller.text =
                    "${value.substring(0, 2)}/${value.substring(2, 5)}$yl";
                controller.selection = const TextSelection.collapsed(offset: 6);
                break;
              default:
                controller.text =
                    "${value.substring(0, 2)}/${value.substring(2, 6)}";
                controller.selection = const TextSelection.collapsed(offset: 7);
                break;
            }
            context.read<Bloc>().add(
                  FieldValueChanged(
                    valueChanged: controller.text,
                    selection: controller.selection,
                  ),
                );
            if (onChanged != null) {
              onChanged!(controller.text);
            }
          },
          cursorWidth: 0.0,
          obscureText: obscureText,
          enabled: enabled,
        );
      },
    );
  }

  void validateTextField(String fieldValue, BuildContext context) {
    if (fieldValue ==
        HomsaiLocalizations.of(context)!
            .photovoltaicInstallationDateStartValue) {
      return context.read<Bloc>().add(const FieldValidate(errorText: ""));
    }
    final date = parseMonthYearDate(fieldValue);
    if (date == null) {
      return context.read<Bloc>().add(
            FieldValidate(
              errorText: HomsaiLocalizations.of(context)!
                  .photovoltaicInstallationDateToComplete,
            ),
          );
    }
    return checkMonthYearDate(fieldValue, date) == false
        ? context.read<Bloc>().add(
              FieldValidate(
                errorText: HomsaiLocalizations.of(context)!
                    .photovoltaicInstallationDateInvalid,
              ),
            )
        : context.read<Bloc>().add(const FieldValidate(errorText: ""));
  }
}

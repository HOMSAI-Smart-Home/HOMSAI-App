import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/themes/colors.theme.dart';

class MonthYearField extends StatelessWidget {
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
    FocusNode focusNode = FocusNode();
    final TextEditingController controller = TextEditingController();
    focusNode.addListener(() {
      if (!focusNode.hasFocus &&
          controller.text ==
              HomsaiLocalizations.of(context)!
                  .photovoltaicInstallationDateStartValue) {
        controller.text = "";
      }
    });
    return TextFormField(
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: false),
      controller: controller,
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
          case 6:
            controller.text =
                "${value.substring(0, 2)}/${value.substring(2, 6)}";
            controller.selection = const TextSelection.collapsed(offset: 7);
            break;
        }
        if (value.length > 6) {
          controller.text = "${value.substring(0, 2)}/${value.substring(2, 6)}";
          controller.selection = const TextSelection.collapsed(offset: 7);
        }
      },
      cursorWidth: 0.0,
      obscureText: obscureText,
      enabled: enabled,
    );
  }
}

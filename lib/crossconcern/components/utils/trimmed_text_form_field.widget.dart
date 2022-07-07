import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrimmedTextFormField extends StatelessWidget {
  const TrimmedTextFormField({
    Key? key,
    this.restorationId,
    this.initialValue,
    this.focusNode,
    this.obscureText = false,
    this.textInputAction,
    this.onChanged,
    this.decoration,
    this.style,
    this.keyboardType,
    this.enabled,
    this.inputFormatters,
  }) : super(key: key);

  final String? restorationId;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      restorationId: restorationId,
      initialValue: initialValue,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value.trim());
        }
      },
      inputFormatters: inputFormatters,
      decoration: decoration,
      enabled: enabled,
      style: style,
      keyboardType: keyboardType,
    );
  }
}

import 'package:flutter/material.dart';

class CheckboxText extends StatefulWidget {
  final Widget? child;
  final void Function(bool?) onChanged;

  const CheckboxText({
    Key? key,
    this.child,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CheckboxText> createState() => _CheckboxText();
}

class _CheckboxText extends State<CheckboxText> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: isChecked,
            onChanged: (isChecked) {
              setState(() {
                this.isChecked = isChecked;
              });
              widget.onChanged(isChecked);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 16),
        if (widget.child != null) widget.child!
      ],
    );
  }
}

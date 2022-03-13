import 'package:flutter/material.dart';

class CheckboxText extends StatefulWidget {
  final Widget? child;

  const CheckboxText({
    Key? key,
    this.child,
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
            },
            activeColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 16),
        if (widget.child != null) widget.child!
      ],
    );
  }
}

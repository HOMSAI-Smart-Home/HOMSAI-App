import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  final bool initialValue;
  final double? width;
  final double? height;
  final double stroke;
  final double radius;
  final bool clickable;
  final void Function(bool)? onChanged;

  const RadioButton(
      {Key? key,
      required this.initialValue,
      this.width = 20,
      this.height = 20,
      this.stroke = 1,
      this.radius = 2,
      this.onChanged,
      this.clickable = true})
      : super(key: key);

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  bool value = false;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  void _toggle() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(
            width: widget.stroke,
            color: getBorderColor(context),
          ),
        ),
        child: InkWell(
          onTap: !widget.clickable || isDisabled()
              ? null
              : () {
                  if (widget.onChanged != null) {
                    _toggle();
                    widget.onChanged!(value);
                  }
                },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Container(
              key: ValueKey(value),
              padding: const EdgeInsets.all(3),
              width: widget.width,
              height: widget.height,
              child: !isDisabled() && value
                  ? CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.transparent,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  bool isDisabled() {
    return widget.onChanged == null;
  }

  Color getBorderColor(BuildContext context) {
    if (isDisabled()) return Theme.of(context).disabledColor;
    return value
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onBackground;
  }
}

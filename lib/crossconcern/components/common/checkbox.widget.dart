import 'package:flutter/material.dart';

class CheckboxButton extends StatefulWidget {
  final bool initialValue;
  final double? width;
  final double? height;
  final double stroke;
  final double radius;
  final void Function(bool)? onChanged;

  const CheckboxButton(
      {Key? key,
      required this.initialValue,
      this.width = 20,
      this.height = 20,
      this.stroke = 1,
      this.radius = 2,
      this.onChanged})
      : super(key: key);

  @override
  State<CheckboxButton> createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              width: widget.stroke,
              color: getBorderColor(context),
            ),
            borderRadius: BorderRadius.circular(widget.radius * 0.5)),
        child: InkWell(
          onTap: isDisabled()
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
                  ? Container(
                      decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ))
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
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

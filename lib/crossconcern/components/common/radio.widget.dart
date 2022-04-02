import 'package:flutter/material.dart';

class HomsaiRadio extends StatelessWidget {
  final bool value;
  final double? width;
  final double? height;
  final double stroke;

  const HomsaiRadio(
      {Key? key,
      required this.value,
      this.width = 20,
      this.height = 20,
      this.stroke = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(
          side: BorderSide(
              width: stroke,
              color: value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Container(
          key: ValueKey(value),
          padding: const EdgeInsets.all(3),
          width: width,
          height: height,
          child: value
              ? CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                )
              : const CircleAvatar(
                  backgroundColor: Colors.transparent,
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_bloc.widget.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_event.widget.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_state.widget.dart';

class CheckboxButton extends StatefulWidget {
  final bool initialValue;
  final double width;
  final double height;
  final double stroke;
  final double radius;

  const CheckboxButton(
      {Key? key,
      required this.initialValue,
      this.width = 20,
      this.height = 20,
      this.stroke = 1,
      this.radius = 2})
      : super(key: key);

  @override
  State<CheckboxButton> createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<CheckboxBloc>(context),
        child: _Checkbox(
          widget.width,
          widget.height,
          widget.stroke,
          widget.radius,
        ));
  }
}

class _Checkbox extends StatelessWidget {
  final double width;
  final double height;
  final double stroke;
  final double radius;

  const _Checkbox(
    this.width,
    this.height,
    this.stroke,
    this.radius,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckboxBloc, CheckboxState>(
        buildWhen: (previous, current) => previous.remote != current.remote,
        builder: (context, state) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                width: stroke,
                color: getBorderColor(context, state.remote, state.disable),
              ),
              borderRadius: BorderRadius.circular(radius * 0.5)),
          child: InkWell(
              onTap: !state.disable
                  ? () => context.read<CheckboxBloc>().add(Toggle())
                  : null,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Container(
                  key: ValueKey(state.remote),
                  padding: const EdgeInsets.all(3),
                  width: width,
                  height: height,
                  child: !state.disable && state.remote
                      ? Container(
                          decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(radius),
                        ))
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(radius),
                          ),
                        ),
                ),
              )),
        ),
      );
    });
  }

  Color getBorderColor(BuildContext context, bool value, bool disable) {
    if (disable) return Theme.of(context).disabledColor;
    return value
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onBackground;
  }
}

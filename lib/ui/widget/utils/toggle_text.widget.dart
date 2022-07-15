import 'package:flutter/material.dart';

class ToggleText extends StatelessWidget {
  final String first;
  final String second;
  final void Function(bool) onChanged;
  final bool isFirstEnabled;

  const ToggleText(
      {Key? key,
      required this.first,
      required this.second,
      required this.onChanged,
      this.isFirstEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ToggleTextButton(
              text: first,
              borderRadius: leftBorder,
              onTap: () => onChanged(true),
              enabled: isFirstEnabled),
          _ToggleTextButton(
              text: second,
              borderRadius: rightBorder,
              onTap: () => onChanged(false),
              enabled: !isFirstEnabled),
        ],
      ),
    );
  }

  BorderRadius get leftBorder => const BorderRadius.only(
      topLeft: Radius.circular(5), bottomLeft: Radius.circular(5));

  BorderRadius get rightBorder => const BorderRadius.only(
      topRight: Radius.circular(5), bottomRight: Radius.circular(5));
}

class _ToggleTextButton extends StatelessWidget {
  final String text;
  final BorderRadius borderRadius;
  final void Function() onTap;
  final bool enabled;

  const _ToggleTextButton(
      {Key? key,
      required this.text,
      required this.borderRadius,
      required this.onTap,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: enabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).disabledColor,
          child: InkWell(
            onTap: enabled ? null : onTap,
            splashColor:
                Theme.of(context).colorScheme.background.withOpacity(0.3),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    height: 1,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

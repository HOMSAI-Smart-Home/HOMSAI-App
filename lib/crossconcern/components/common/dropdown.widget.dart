import 'package:flutter/material.dart';

class HomsaiDropdownButton<T extends Object> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;

  const HomsaiDropdownButton({
    Key? key,
    required this.label,
    required this.hint,
    this.value,
    this.items,
    this.onChanged,
  }) : super(key: key);

  bool get isDisabled => items?.isEmpty ?? true;

  Color color(BuildContext context) => (isDisabled)
      ? Theme.of(context).disabledColor
      : Theme.of(context).colorScheme.onBackground;

  BoxBorder border(BuildContext context) => Border.all(color: color(context));

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(60),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: border(context),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 16),
                child: DropdownButton<T>(
                  value: value,
                  hint: Text(
                    hint,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  items: items,
                  onChanged: onChanged,
                  underline: const SizedBox.shrink(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  isExpanded: true,
                  isDense: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: 10,
                        color: color(context),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class HomsaiDropdownButton<T extends Object> extends StatefulWidget {
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

  @override
  State<HomsaiDropdownButton<T>> createState() =>
      _HomsaiDropdownButtonState<T>();
}

class _HomsaiDropdownButtonState<T extends Object>
    extends State<HomsaiDropdownButton<T>> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isDisabled => widget.items?.isEmpty ?? true;

  Color color(BuildContext context) => (isDisabled)
      ? Theme.of(context).disabledColor
      : Theme.of(context).colorScheme.onBackground;

  BoxBorder border(BuildContext context) => Border.all(color: color(context));

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(68),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                value: widget.value,
                hint: Text(
                  widget.hint,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: Theme.of(context).textTheme.bodyText1,
                items: widget.items,
                onChanged: widget.onChanged,
                onMenuStateChange: (open) =>
                    (open) ? _controller.forward() : _controller.reverse(),
                icon: RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                isExpanded: true,
                buttonPadding: const EdgeInsets.only(left: 24, right: 16, top: 5, bottom: 5),
                buttonDecoration: BoxDecoration(
                  border: border(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 4,
                scrollbarAlwaysShow: true,
                dropdownMaxHeight: 200,
                dropdownDecoration: BoxDecoration(
                  border: border(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                offset: const Offset(0, -2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    widget.label,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 10,
                          color: color(context),
                        ),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CheckboxHomsai extends StatefulWidget {
  const CheckboxHomsai({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckboxHomsai> createState() => _CheckboxHomsai();
}

class _CheckboxHomsai extends State<CheckboxHomsai> {
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
        Flexible(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle2,
              children: <TextSpan>[
                const TextSpan(
                  text: "Ho letto e accetto i termini ",
                ),
                TextSpan(
                  text: 'Termini e Condizioni',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

import 'bullet.widget.dart';

class ShowDialog extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? Function(BuildContext) content;

  const ShowDialog(
      {Key? key, this.child, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: content(context),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            titlePadding:
                const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 0),
            contentPadding:
                const EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 0),
            scrollable: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: HomsaiColors.primaryWhite,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    HomsaiLocalizations.of(context)!.ok,
                    style: const TextStyle(
                        color: HomsaiColors.primaryGreen,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      },
      child: child,
    );
  }
}

List<Widget> dialogParagraph(
  String content, {
  bool? removeBottomPadding,
  String? title,
}) {
  return [
    if (title != null)
      Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(color: HomsaiColors.primaryGreen),
      ),
    const SizedBox(height: 5),
    Text(content,
        textAlign: TextAlign.left,
        style: const TextStyle(color: HomsaiColors.primaryWhite)),
    if (removeBottomPadding != true) const SizedBox(height: 15),
  ];
}

Widget bulletListItem(
  String title,
  String content, {
  Color color = HomsaiColors.primaryWhite,
}) {
  return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Bullet(),
        ],
      ),
      horizontalTitleGap: -25,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      title: Text.rich(TextSpan(
          style: const TextStyle(fontWeight: FontWeight.w300),
          children: [
            TextSpan(
              text: title,
              style: TextStyle(color: color),
            ),
            TextSpan(
                text: content,
                style: const TextStyle(color: HomsaiColors.primaryWhite)),
          ])));
}

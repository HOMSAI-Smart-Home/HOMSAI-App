import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';

class Bullet extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const Bullet({
    Key? key,
    this.width = 2.5,
    this.height = 2.5,
    this.color = HomsaiColors.primaryWhite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

enum DeviceStatus { disabled, enabled, warning, error, group }

extension DeviceStatusX on DeviceStatus {
  bool get isGroup => this == DeviceStatus.group;
}

class Device extends StatefulWidget {
  const Device(
    this.status, {
    Key? key,
    required this.iconPath,
    required this.baseColor,
    required this.title,
    required this.room,
    required this.info,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final DeviceStatus status;
  final String iconPath;
  final Color baseColor;
  final String title;
  final String room;
  final String info;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  Widget buildIcon(Device device) {
    switch (device.status) {
      case DeviceStatus.group:
      case DeviceStatus.disabled:
      case DeviceStatus.enabled:
        return SvgPicture.asset(
          device.iconPath,
          color: getColor(device),
          height: 50,
        );
      case DeviceStatus.warning:
        return SvgPicture.asset(
          "assets/icons/info.svg",
          color: getColor(device),
          height: 50,
        );
      case DeviceStatus.error:
        return SvgPicture.asset(
          "assets/icons/warning.svg",
          color: getColor(device),
          height: 50,
        );
    }
  }

  Color getColor(Device device) {
    switch (device.status) {
      case DeviceStatus.group:
      case DeviceStatus.enabled:
        return device.baseColor;
      case DeviceStatus.disabled:
        return HomsaiColors.primaryGrey;
      case DeviceStatus.warning:
        return HomsaiColors.tertiaryYellow;
      case DeviceStatus.error:
        return HomsaiColors.primaryRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shadow(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      sigma: 1,
      offset: const Offset(0, 2),
      color: getColor(widget),
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          splashColor: getColor(widget).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (widget.status.isGroup)
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.house,
                                            size: 20,
                                            color: HomsaiColors.primaryGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: HomsaiLocalizations.of(context)!
                                              .groupDeviceGeneralLabel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                height: 1,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    widget.room,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyText2!,
                                  ),
                            const SizedBox(height: 12),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                widget.info.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      color: getColor(widget),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildIcon(widget)
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

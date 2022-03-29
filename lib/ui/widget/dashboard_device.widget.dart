import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/widget/shadow.widget.dart';

enum DeviceStatus { disabled, enabled, warning, error, group }

extension DeviceStatusX on DeviceStatus {
  bool get isGroup => this == DeviceStatus.group;
}

class DashboardDevice extends StatefulWidget {
  const DashboardDevice(this.status,
      {Key? key,
      required this.baseIcon,
      required this.baseColor,
      required this.title,
      required this.room,
      required this.info})
      : super(key: key);

  final DeviceStatus status;
  final IconData baseIcon;
  final Color baseColor;
  final String title;
  final String room;
  final String info;

  @override
  State<DashboardDevice> createState() => _DashboardDeviceState();
}

class _DashboardDeviceState extends State<DashboardDevice> {
  Widget getIcon(DashboardDevice device) {
    switch (device.status) {
      case DeviceStatus.group:
      case DeviceStatus.disabled:
      case DeviceStatus.enabled:
        return Icon(
          device.baseIcon,
          size: 32,
          color: getColor(device),
        );
      case DeviceStatus.warning:
        return Icon(
          Icons.info_rounded,
          size: 32,
          color: getColor(device),
        );
      case DeviceStatus.error:
        return Icon(
          Icons.warning_rounded,
          size: 32,
          color: getColor(device),
        );
    }
  }

  Color getColor(DashboardDevice device) {
    switch (device.status) {
      case DeviceStatus.group:
      case DeviceStatus.enabled:
        return device.baseColor;
      case DeviceStatus.disabled:
        return HomsaiColors.primaryGrey;
      case DeviceStatus.warning:
        return HomsaiColors.secondaryYellow;
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.title,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
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
                                      text: " Generale",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                widget.room,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                        const SizedBox(height: 12),
                        Text(
                          widget.info.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: getColor(widget),
                                  ),
                        )
                      ],
                    ),
                    getIcon(widget)
                  ],
                )
              ]),
        ),
      ),
    );
  }
}

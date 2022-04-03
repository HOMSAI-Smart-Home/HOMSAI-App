import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/widget/devices/device.widget.dart';
import 'package:homsai/ui/widget/devices/light/bloc/light_device.bloc.dart';

class LightDevice extends StatefulWidget {
  const LightDevice({Key? key, required this.light}) : super(key: key);

  final LightEntity light;

  @override
  State<LightDevice> createState() => _LightDeviceState();
}

class _LightDeviceState extends State<LightDevice> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LightDeviceBloc(widget.light),
      child: BlocBuilder<LightDeviceBloc, LightDeviceState>(
        buildWhen: (previous, current) => previous.light != current.light,
        builder: (context, state) => buildDevice(context, state.light),
      ),
    );
  }

  Device buildDevice(BuildContext context, LightEntity light) {
    return Device(
      (light.isOn) ? DeviceStatus.enabled : DeviceStatus.disabled,
      baseIcon: Icons.lightbulb,
      baseColor: HomsaiColors.primaryYellow,
      title: light.attributes.friendlyName,
      room: "Camera",
      info: (light.isOn) ? "on" : "off",
      onTap: () {
        context
            .read<LightDeviceBloc>()
            .add((light.isOn) ? LightOff(light) : LightOn(light));
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(light.attributes.friendlyName),
              ],
            );
          },
          useRootNavigator: true,
        );
      },
    );
  }
}

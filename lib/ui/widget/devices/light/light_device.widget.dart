import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      child: _LightDeviceCard(),
    );
  }
}

class _LightDeviceCard extends StatefulWidget {
  @override
  State<_LightDeviceCard> createState() => _LightDeviceCardState();
}

class _LightDeviceCardState extends State<_LightDeviceCard> {
  @override
  void initState() {
    context.read<LightDeviceBloc>().add(LightOnChanged());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LightDeviceBloc, LightDeviceState>(
        buildWhen: (previous, current) => previous.light != current.light,
        builder: buidDevice);
  }

  Widget buidDevice(BuildContext context, LightDeviceState state) {
    return Device(
      (state.light.isOn) ? DeviceStatus.enabled : DeviceStatus.disabled,
      iconPath: "assets/icons/bulb.svg",
      baseColor: HomsaiColors.primaryYellow,
      title: state.light.attributes.friendlyName,
      room: "Camera",
      info: (state.light.isOn) ? "on" : "off",
      onTap: () {
        context.read<LightDeviceBloc>().add(
            (state.light.isOn) ? LightOff(state.light) : LightOn(state.light));
      },
      /*
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.light.attributes.friendlyName),
                ],
              );
            },
            useRootNavigator: true,
          );
        },
        */
    );
  }
}

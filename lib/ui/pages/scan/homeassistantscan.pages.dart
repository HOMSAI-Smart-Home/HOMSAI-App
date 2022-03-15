import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class HomeAssistantScanPage extends StatefulWidget {
  const HomeAssistantScanPage({Key? key}) : super(key: key);

  @override
  State<HomeAssistantScanPage> createState() => _HomeAssistantScanPage();
}

class _HomeAssistantScanPage extends State<HomeAssistantScanPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/full_logo.svg",
              height: 20,
            ),
            const Spacer(),
            const Text("Ricerca istanza locale"),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Card(
                color: Color(0x4D56BB76),
                elevation: 5,
                shadowColor: Color(0xFF000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    ListTile(
                      leading: Icon(Icons.warning_rounded),
                      title: Text('Connettiti al WI-FI!'),
                      subtitle: Text(
                          'Lorem Ipsum sit dolor at met. Lorem Ipsum sit dolor at met. Lorem Ipsum sit dolor at met. Lorem Ipsum sit dolor at met. '),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Icon(
              Icons.hourglass_bottom_rounded,
              color: Color(0xFFFFFFFF),
              size: 48,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

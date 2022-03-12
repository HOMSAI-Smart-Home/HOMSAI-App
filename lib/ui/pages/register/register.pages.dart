import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homsai/ui/widget/checkbox.widget.dart';
import 'package:homsai/ui/widget/shadow.widget.dart';
import 'package:homsai/ui/widget/textfield.widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _Body());
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 20),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline4,
                      children: <TextSpan>[
                        const TextSpan(
                          text: "rendi\nla tua casa \n",
                        ),
                        TextSpan(
                          text: 'davvero\n',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        const TextSpan(
                          text: "intelligente",
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset("assets/icons/logo.svg"),
                ),
              ],
            ),
          ),
          Shadow(
            child: SvgPicture.asset(
              "assets/icons/banner.svg",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            offset: const Offset(0, 5),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  const EmailAddressTextField(),
                  const SizedBox(height: 16),
                  const PasswordTextField(),
                  const SizedBox(height: 16),
                  const CheckboxHomsai(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      primary: Theme.of(context).colorScheme.primary,
                      onSurface: Theme.of(context).colorScheme.onBackground,
                      textStyle: Theme.of(context).textTheme.headline6,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Registrati'),
                  ),
                  const SizedBox(
                    height: 128, // offset
                  ),
                  const Spacer(),
                  const Text("Hai già un account?"),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "LoginPage");
                    },
                    child: const Text("Effettua l'accesso"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

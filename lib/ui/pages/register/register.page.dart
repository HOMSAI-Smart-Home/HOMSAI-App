import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homsai/crossconcern/components/utils/credentials_form/credentials_form.widget.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

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
                      style: Theme.of(context).textTheme.headline1,
                      children: <TextSpan>[
                        TextSpan(
                          text: HomsaiLocalizations.of(context)!.registerTitle1,
                        ),
                        TextSpan(
                          text: HomsaiLocalizations.of(context)!.registerTitle2,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        TextSpan(
                          text: HomsaiLocalizations.of(context)!.registerTitle3,
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
                  CredentialsForm(
                    submitLabel: HomsaiLocalizations.of(context)!.register,
                    hasAgreeement: true,
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 128, // offset
                  ),
                  const Spacer(),
                  Text(HomsaiLocalizations.of(context)!.alradySignUp),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: () {},
                    child:
                        Text(HomsaiLocalizations.of(context)!.registerToLogin),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/ui/widget/utils/credentials_form/credentials_form.widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _Body());
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
                          text: HomsaiLocalizations.of(context)!.loginTitle1,
                        ),
                        TextSpan(
                          text: HomsaiLocalizations.of(context)!.loginTitle2,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  CredentialsForm(
                    submitLabel: HomsaiLocalizations.of(context)!.login,
                  ),
                  const Spacer(),
                  Text(HomsaiLocalizations.of(context)!.notSignUp),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: () {},
                    child: Text(HomsaiLocalizations.of(context)!.register),
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

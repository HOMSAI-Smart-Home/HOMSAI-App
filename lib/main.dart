import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.dart';
import 'package:homsai/themes/homsai_theme_data.dart';

final getIt = GetIt.instance;

void setup() {
  // It enables to reassign an implementation of an interface, for example in Unit tests
  getIt.allowReassignment = true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize singletons
  setup();

  runApp(const HomsaiApp());
}

class HomsaiApp extends StatelessWidget {
  const HomsaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: appName,
      theme: HomsaiThemeData.lightThemeData,
      localizationsDelegates: const [
        ...HomsaiLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate()
      ],
      supportedLocales: HomsaiLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                const _EmailAddressTextField(),
                const SizedBox(height: 24),
                const _PasswordTextField(),
                const SizedBox(height: 24),
                Theme(
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Ho letto e accetto i ",
                          ),
                          TextSpan(
                            text: 'Termini e Condizioni',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    checkColor: Theme.of(context).colorScheme.secondary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: true,
                    onChanged: (checked) {},
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  data: ThemeData(
                    unselectedWidgetColor:
                        const Color(0xFFF2F2F2), // Your color
                  ),
                ),
                const SizedBox(height: 24),
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
                const Spacer(),
                const Text("Hai già un account?"),
                const SizedBox(height: 24),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: () {},
                    child: const Text("Effettua l'accesso"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailAddressTextField extends StatelessWidget {
  const _EmailAddressTextField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      restorationId: 'emailaddress_text_field',
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email_rounded,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        labelText: HomsaiLocalizations.of(context)!.emailAddress,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      restorationId: 'password_text_field',
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_rounded,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        labelText: HomsaiLocalizations.of(context)!.password,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.util.dart';
import 'package:homsai/routes.dart';
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
      initialRoute: '/register',
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }
}

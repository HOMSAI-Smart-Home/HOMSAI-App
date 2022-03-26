import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_plant/add_plant.pages.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.pages.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.routes.dart';
import 'package:homsai/ui/pages/login/login.pages.dart';
import 'package:homsai/ui/pages/register/register.pages.dart';
import 'package:homsai/ui/pages/register/register.routes.dart'
    as register_routes;
import 'package:homsai/ui/pages/login/login.routes.dart' as login_routes;
import 'package:homsai/ui/pages/scan/home_assistant_scan.pages.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.routes.dart'
    as has_routes;
import 'package:homsai/ui/pages/add_plant/add_plant.routes.dart'
    as add_implant_routes;
import 'package:homsai/ui/pages/dashboard/dashboard.routes.dart'
    as dashboard_routes;

typedef PathWidgetBuilder = Widget Function(BuildContext, String?);

class Path {
  const Path(this.pattern, this.builder);

  /// A RegEx string for route matching.
  final String pattern;

  /// The builder for the associated pattern route. The first argument is the
  /// [BuildContext] and the second argument a RegEx match if that is included
  /// in the pattern.
  ///
  /// ```dart
  /// Path(
  ///   'r'^/login/([\w-]+)$',
  ///   (context, matches) => Page(argument: match),
  /// )
  /// ```
  final PathWidgetBuilder builder;
}

class RouteConfiguration {
  static const String initialRoute = dashboard;
  static const String login = login_routes.defaultRoute;
  static const String register = register_routes.defaultRoute;
  static const String homeAssistantScan = has_routes.defaultRoute;
  static const String addPlant = add_implant_routes.defaultRoute;
  static const String dashboard = dashboard_routes.defaultRoute;

  /// List of [Path] to for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [Path.pattern]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  static List<Path> paths = [
    Path(
      r'^' + login,
      (context, match) => const LoginPage(),
    ),
    Path(
      r'^' + register,
      (context, match) => const RegisterPage(),
    ),
    Path(
      r'^' + homeAssistantScan,
      (context, match) => const HomeAssistantScanPage(),
    ),
    Path(
      r'^' + addPlant,
      (context, match) => const AddPlantPage(),
    ),
    Path(
      r'^' + dashboard,
      (context, match) => const DashboardPage(),
    ),
  ];

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    for (final path in paths) {
      final regExpPattern = RegExp(path.pattern);
      final name = settings.name ?? "";
      if (name.isNotEmpty && regExpPattern.hasMatch(name)) {
        final firstMatch = regExpPattern.firstMatch(name);
        final match =
            (firstMatch?.groupCount == 1) ? firstMatch?.group(1) : null;
        if (kIsWeb) {
          return NoAnimationMaterialPageRoute<void>(
            builder: (context) => path.builder(context, match),
            settings: settings,
          );
        }
        return CupertinoPageRoute<void>(
          builder: (context) => Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              path.builder(context, match),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    appVersion ?? "",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              )
            ],
          ),
          settings: settings,
        );
      }
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }
}

class NoAnimationMaterialPageRoute<T> extends CupertinoPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

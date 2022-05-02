import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/user.entity.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_plant/add_plant.page.dart';
import 'package:homsai/ui/pages/add_sensor/add_sensor.page.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/history/history.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/home.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/search/search.page.dart';
import 'package:homsai/ui/pages/intro_beta/intro_beta.page.dart';
import 'package:homsai/ui/pages/introduction/introduction.page.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';
import 'package:timezone/timezone.dart';
import 'package:homsai/ui/pages/url_update/url_update.page.dart';

part 'app.router.gr.dart';
part 'package:homsai/ui/pages/add_sensor/add_sensor.router.dart';
part 'package:homsai/ui/pages/dashboard/dashboard.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/home/home.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/history/history.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/search/search.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.router.dart';
part 'package:homsai/ui/pages/add_plant/add_plant.router.dart';
part 'package:homsai/ui/pages/scan/home_assistant_scan.router.dart';
part 'package:homsai/ui/pages/introduction/introduction.routes.dart';
part 'package:homsai/ui/pages/intro_beta/intro_beta.router.dart';
part 'package:homsai/ui/pages/url_update/url_update.router.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: homeAssistantScanPath,
      page: HomeAssistantScanPage,
    ),
    AutoRoute(path: addPlantPath, page: AddPlantPage),
    AutoRoute(path: addSensorPath, page: AddSensorPage),
    AutoRoute(
      path: dashboardPath,
      page: DashboardPage,
      children: dashboardChildrenRoutes,
      guards: [AuthGuard],
      initial: true,
    ),
    AutoRoute(
      path: introductionPath,
      page: IntroductionPage,
    ),
    AutoRoute(
      path: introBetaPath,
      page: IntroBetaPage,
    ),
    AutoRoute(
      path: urlUpdatePath,
      page: UrlUpdatePage,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required AuthGuard authGuard}) : super(authGuard: authGuard);
}

class AuthGuard extends AutoRouteGuard {
  final AppDatabase _appDatabase = getIt.get<AppDatabase>();
  final AppPreferencesInterface _appPreferences =
      getIt.get<AppPreferencesInterface>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final AuthGuardBuilder builder = AuthGuardBuilder();

    final String? userId = _appPreferences.getUserId();
    final User? user = await _appDatabase.userDao.findUserById(userId ?? "");
    if (userId == null || user == null) {
      builder.guard((onResult) => IntroBetaRoute(onResult: onResult));
    }

    if (!_appPreferences.canSkipIntroduction()) {
      builder.guard(
        (onResult) => IntroductionRoute(onResult: onResult),
        optional: () => _appPreferences.setIntroduction(true),
      );
    }

    if (user == null || user.isPlantNotAvailable) {
      builder.guard((onResult) => HomeAssistantScanRoute(onResult: onResult));
    }

    builder.next(
      resolver,
      router,
      onSuccess: () async {
        final appDatabase = getIt.get<AppDatabase>();
        Configuration? configuration = await appDatabase.getConfiguration();
        if (configuration != null) {
          getIt.registerLazySingleton<Location>(
              () => getLocation(configuration.timezone));
        }
      },
    );
  }
}

typedef CallbackRoute = PageRouteInfo<dynamic> Function(void Function(bool));

class AuthGuardBuilder {
  final List<CallbackRoute> routes = [];
  final List<void Function()?> optionals = [];

  AuthGuardBuilder guard(CallbackRoute route, {void Function()? optional}) {
    routes.add(route);
    optionals.add(optional);
    return this;
  }

  void next(NavigationResolver resolver, StackRouter router,
      {void Function()? onSuccess}) {
    final build = _buildRedirect(resolver, router, (success) {
      if (success && onSuccess != null) onSuccess();
      resolver.next(success);
    });
    build(true);
  }

  void Function(bool) _buildRedirect(NavigationResolver resolver,
      StackRouter router, void Function(bool) previous) {
    if (routes.isEmpty) return previous;
    final redirect = routes.removeLast();
    final optional = optionals.removeLast();
    return _buildRedirect(
      resolver,
      router,
      (success) => router.replace(redirect((success) {
        if (optional != null) optional();
        previous(success);
      })),
    );
  }
}

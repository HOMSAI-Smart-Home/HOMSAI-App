import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:homsai/ui/widget/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/user.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_plant/add_plant.page.dart';
import 'package:homsai/ui/pages/add_sensor/add_sensor.page.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/history/history.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/home.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/search/search.page.dart';
import 'package:homsai/ui/pages/intro_beta/bloc/intro_beta.bloc.dart';
import 'package:homsai/ui/pages/intro_beta/intro_beta.page.dart';
import 'package:homsai/ui/pages/introduction/introduction.page.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';
import 'package:timezone/timezone.dart';
import 'package:homsai/ui/pages/url_update/url_update.page.dart';

import 'ui/pages/scan/bloc/home_assistant_scan.bloc.dart';

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
    AutoRoute(
      path: addPlantPath,
      page: AddPlantPage,
    ),
    AutoRoute(
      path: addSensorPath,
      page: AddSensorPage,
    ),
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
    AutoRoute(
      path: accountsPath,
      page: AccountsPage,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required AuthGuard authGuard}) : super(authGuard: authGuard);
}

class AuthGuard extends AutoRouteGuard {
  final HomsaiDatabase _appDatabase = getIt.get<HomsaiDatabase>();
  final AppPreferencesInterface _appPreferences =
      getIt.get<AppPreferencesInterface>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final AuthGuardBuilder builder = AuthGuardBuilder();

    final String? userId = _appPreferences.getUserId();
    final User? user = await _appDatabase.userDao.findUserById(userId ?? "");
    if (userId == null || user == null) {
      builder.guard((onResult) async => IntroBetaRoute(onResult: onResult));
    }

    if (!_appPreferences.canSkipIntroduction()) {
      builder.guard(
        (onResult) async => IntroductionRoute(onResult: onResult),
        optional: () => _appPreferences.setIntroduction(true),
      );
    }

    builder.guard((onResult) async {
      final User? user = await _appDatabase.getUser();
      final HomeAssistantAuth? token = _appPreferences.getHomeAssistantToken();
      if (token == null || user == null || user.isPlantNotAvailable) {
        return HomeAssistantScanRoute(onResult: onResult);
      }
      return null;
    });

    builder.next(
      resolver,
      router,
      onSuccess: () async {
        final HomsaiDatabase appDatabase = getIt.get<HomsaiDatabase>();
        final plant = await appDatabase.getPlant();

        /*HomeAssistantAuth? auth =
            appPreferencesInterface.getHomeAssistantToken();
        if (!webSocketRepository.isConnected() &&
            !webSocketRepository.isConnecting() &&
            auth != null) {
          await webSocketRepository.connect(
            onConnected: () => webSocketRepository.fetchingConfig(
              WebSocketSubscriber(
                (data) async {
                  final configuration =
                      Configuration.fromDto(ConfigurationDto.fromJson(data));
                  await appDatabase.configurationDao.updateItem(
                    configuration,
                  );
                  getIt.registerLazySingleton<Location>(
                      () => getLocation(configuration.timezone));
                },
              ),
            ),
          );
        }*/

        if (plant != null) {
          Configuration? configuration = await appDatabase.getConfiguration();
          if (configuration != null) {
            getIt.registerLazySingleton<Location>(
                () => getLocation(configuration.timezone));
          }
        }
      },
    );
  }
}

typedef CallbackRoute = Future<PageRouteInfo<dynamic>?> Function(
    void Function(bool));

class AuthGuardBuilder {
  final List<CallbackRoute> routes = [];
  final List<void Function()?> optionals = [];

  AuthGuardBuilder guard(CallbackRoute route, {void Function()? optional}) {
    routes.add(route);
    optionals.add(optional);
    return this;
  }

  void next(NavigationResolver resolver, StackRouter router,
      {Future<void> Function()? onSuccess}) async {
    final build = _buildRedirect(resolver, router, (success) async {
      router.removeUntil((route) => false);
      if (success && onSuccess != null) await onSuccess();
      resolver.next(success);
    });
    (await build)(true);
  }

  Future<void Function(bool p1)> _buildRedirect(NavigationResolver resolver,
      StackRouter router, void Function(bool) previous) async {
    if (routes.isEmpty) return previous;
    final redirect = routes.removeLast();
    final optional = optionals.removeLast();

    onResult(success) {
      if (optional != null) optional();
      previous(success);
    }

    return _buildRedirect(
      resolver,
      router,
      (success) async {
        final redirectRoute = await redirect(onResult);

        if (router.navigatorKey.currentState != null) router.popUntilRoot();
        redirectRoute != null
            ? router.replace(redirectRoute)
            : onResult(success);
      },
    );
  }
}

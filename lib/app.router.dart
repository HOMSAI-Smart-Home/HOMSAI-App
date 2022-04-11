import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_plant/add_plant.page.dart';
import 'package:homsai/ui/pages/add_sensor/add_sensor.page.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/history/history.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/home.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/search/search.page.dart';
import 'package:homsai/ui/pages/introduction/introduction.page.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';

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
    )
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
    bool isNotAuthenticated =
        await _appDatabase.plantDao.getActivePlant() == null;

    if (isNotAuthenticated) {
      final scanner = HomeAssistantScanRoute(onResult: (success) {
        resolver.next(success);
      });

      if (!_appPreferences.canSkipIntroduction()) {
        router.popAndPush(IntroductionRoute(onResult: (success) {
          _appPreferences.setIntroduction(true);
          router.popAndPush(scanner);
        }));
        return;
      }

      router.popAndPush(scanner);
      return;
    }

    router.popAndPush(AddPlantRoute(onResult: (success) {
      resolver.next(true);
    }));
    return;
    resolver.next(true);
  }
}

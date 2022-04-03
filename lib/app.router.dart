import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:homsai/ui/pages/add_plant/add_plant.page.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/history/history.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/home.page.dart';
import 'package:homsai/ui/pages/dashboard/tabs/search/search.page.dart';
import 'package:homsai/ui/pages/introduction/introduction.page.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';

part 'app.router.gr.dart';
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
    AutoRoute(path: homeAssistantScanPath, page: HomeAssistantScanPage),
    AutoRoute(path: addPlantPath, page: AddPlantPage),
    AutoRoute(
      path: dashboardPath,
      page: DashboardPage,
      children: dashboardChildrenRoutes,
      initial: true,
    ),
    AutoRoute(path: introductionPath, page: IntroductionPage)
  ],
)
class AppRouter extends _$AppRouter {}

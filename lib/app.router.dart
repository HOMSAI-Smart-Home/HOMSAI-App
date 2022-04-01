import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:homsai/ui/pages/add_plant/add_plant.pages.dart';
import 'package:homsai/ui/pages/dashboard/dashboard.pages.dart';
import 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.pages.dart';
import 'package:homsai/ui/pages/dashboard/tabs/history/history.pages.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/home.pages.dart';
import 'package:homsai/ui/pages/dashboard/tabs/search/search.pages.dart';
import 'package:homsai/ui/pages/introduction/introduction.pages.dart';
import 'package:homsai/ui/pages/introduction/introduction.routes.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.pages.dart';

part 'app.router.gr.dart';
part 'package:homsai/ui/pages/dashboard/dashboard.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/home/home.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/history/history.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/search/search.router.dart';
part 'package:homsai/ui/pages/dashboard/tabs/accounts/accounts.router.dart';
part 'package:homsai/ui/pages/add_plant/add_plant.router.dart';
part 'package:homsai/ui/pages/scan/home_assistant_scan.router.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: homeAssistantScanPath,
      page: HomeAssistantScanPage,
    ),
    AutoRoute(path: addPlantPath, page: AddPlantPage),
    AutoRoute(
        path: dashboardPath,
        page: DashboardPage,
        children: dashboardChildrenRoutes,
    ),
    AutoRoute(
      path: introductionPath,
      page: IntroductionPage,
      initial: true
    )
  ],
)
class AppRouter extends _$AppRouter {}

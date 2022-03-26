part of 'package:homsai/app.router.dart';

const String dashboardPath = '/dashboard';

// Dashboard Bottom Navigation Bar icon order
enum DashboardNavigation {
  home,
  history,
  search,
  accounts,
}

const Map<DashboardNavigation, PageRouteInfo<dynamic>> dashboardTabRoutes = {
  DashboardNavigation.home: HomeRoute(),
  DashboardNavigation.history: HistoryRoute(),
  DashboardNavigation.search: SearchRoute(),
  DashboardNavigation.accounts: AccountsRoute(),
};

const List<AutoRoute<dynamic>> dashboardChildrenRoutes = [
  RedirectRoute(path: '', redirectTo: homePath),
  AutoRoute(path: homePath, page: HomePage),
  AutoRoute(path: historyPath, page: HistoryPage),
  AutoRoute(path: searchPath, page: SearchPage),
  AutoRoute(path: accountsPath, page: AccountsPage),
];

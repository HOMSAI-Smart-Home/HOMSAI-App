// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app.router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter(
      {GlobalKey<NavigatorState>? navigatorKey, required this.authGuard})
      : super(navigatorKey);

  final AuthGuard authGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeAssistantScanRoute.name: (routeData) {
      final args = routeData.argsAs<HomeAssistantScanRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: HomeAssistantScanPage(
              key: args.key,
              onResult: args.onResult,
              scanBloc: args.scanBloc,
              doubleUrlBloc: args.doubleUrlBloc));
    },
    AddPlantRoute.name: (routeData) {
      final args = routeData.argsAs<AddPlantRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: AddPlantPage(
              key: args.key,
              onResult: args.onResult,
              localUrl: args.localUrl,
              remoteUrl: args.remoteUrl,
              wizard: args.wizard));
    },
    AddSensorRoute.name: (routeData) {
      final args = routeData.argsAs<AddSensorRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: AddSensorPage(
              key: args.key,
              onResult: args.onResult,
              wizard: args.wizard,
              url: args.url));
    },
    DashboardRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const DashboardPage());
    },
    IntroductionRoute.name: (routeData) {
      final args = routeData.argsAs<IntroductionRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: IntroductionPage(
              key: args.key, onResult: args.onResult, page: args.page));
    },
    IntroBetaRoute.name: (routeData) {
      final args = routeData.argsAs<IntroBetaRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: IntroBetaPage(
              key: args.key,
              onResult: args.onResult,
              introBetaBloc: args.introBetaBloc));
    },
    UrlUpdateRoute.name: (routeData) {
      final args = routeData.argsAs<UrlUpdateRouteArgs>();
      return CupertinoPageX<dynamic>(
          routeData: routeData,
          child: UrlUpdatePage(
              key: args.key, onResult: args.onResult, wizard: args.wizard));
    },
    AccountsRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const AccountsPage());
    },
    HomeRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const HomePage());
    },
    HistoryRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const HistoryPage());
    },
    SearchRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
          routeData: routeData, child: const SearchPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig('/#redirect',
            path: '/', redirectTo: '/dashboard', fullMatch: true),
        RouteConfig(HomeAssistantScanRoute.name, path: '/scanner'),
        RouteConfig(AddPlantRoute.name, path: '/add-plant'),
        RouteConfig(AddSensorRoute.name, path: '/add-sensor'),
        RouteConfig(DashboardRoute.name, path: '/dashboard', guards: [
          authGuard
        ], children: [
          RouteConfig('#redirect',
              path: '',
              parent: DashboardRoute.name,
              redirectTo: 'home',
              fullMatch: true),
          RouteConfig(HomeRoute.name,
              path: 'home', parent: DashboardRoute.name),
          RouteConfig(HistoryRoute.name,
              path: 'history', parent: DashboardRoute.name),
          RouteConfig(SearchRoute.name,
              path: 'search', parent: DashboardRoute.name)
        ]),
        RouteConfig(IntroductionRoute.name, path: '/introduction'),
        RouteConfig(IntroBetaRoute.name, path: '/intro-beta'),
        RouteConfig(UrlUpdateRoute.name, path: '/url-update'),
        RouteConfig(AccountsRoute.name, path: 'accounts')
      ];
}

/// generated route for
/// [HomeAssistantScanPage]
class HomeAssistantScanRoute extends PageRouteInfo<HomeAssistantScanRouteArgs> {
  HomeAssistantScanRoute(
      {Key? key,
      required void Function(bool) onResult,
      HomeAssistantScanBloc? scanBloc,
      DoubleUrlBloc? doubleUrlBloc})
      : super(HomeAssistantScanRoute.name,
            path: '/scanner',
            args: HomeAssistantScanRouteArgs(
                key: key,
                onResult: onResult,
                scanBloc: scanBloc,
                doubleUrlBloc: doubleUrlBloc));

  static const String name = 'HomeAssistantScanRoute';
}

class HomeAssistantScanRouteArgs {
  const HomeAssistantScanRouteArgs(
      {this.key, required this.onResult, this.scanBloc, this.doubleUrlBloc});

  final Key? key;

  final void Function(bool) onResult;

  final HomeAssistantScanBloc? scanBloc;

  final DoubleUrlBloc? doubleUrlBloc;

  @override
  String toString() {
    return 'HomeAssistantScanRouteArgs{key: $key, onResult: $onResult, scanBloc: $scanBloc, doubleUrlBloc: $doubleUrlBloc}';
  }
}

/// generated route for
/// [AddPlantPage]
class AddPlantRoute extends PageRouteInfo<AddPlantRouteArgs> {
  AddPlantRoute(
      {Key? key,
      required void Function(bool) onResult,
      String? localUrl,
      String? remoteUrl,
      bool wizard = true})
      : super(AddPlantRoute.name,
            path: '/add-plant',
            args: AddPlantRouteArgs(
                key: key,
                onResult: onResult,
                localUrl: localUrl,
                remoteUrl: remoteUrl,
                wizard: wizard));

  static const String name = 'AddPlantRoute';
}

class AddPlantRouteArgs {
  const AddPlantRouteArgs(
      {this.key,
      required this.onResult,
      this.localUrl,
      this.remoteUrl,
      this.wizard = true});

  final Key? key;

  final void Function(bool) onResult;

  final String? localUrl;

  final String? remoteUrl;

  final bool wizard;

  @override
  String toString() {
    return 'AddPlantRouteArgs{key: $key, onResult: $onResult, localUrl: $localUrl, remoteUrl: $remoteUrl, wizard: $wizard}';
  }
}

/// generated route for
/// [AddSensorPage]
class AddSensorRoute extends PageRouteInfo<AddSensorRouteArgs> {
  AddSensorRoute(
      {Key? key,
      required void Function(bool) onResult,
      bool wizard = true,
      Uri? url})
      : super(AddSensorRoute.name,
            path: '/add-sensor',
            args: AddSensorRouteArgs(
                key: key, onResult: onResult, wizard: wizard, url: url));

  static const String name = 'AddSensorRoute';
}

class AddSensorRouteArgs {
  const AddSensorRouteArgs(
      {this.key, required this.onResult, this.wizard = true, this.url});

  final Key? key;

  final void Function(bool) onResult;

  final bool wizard;

  final Uri? url;

  @override
  String toString() {
    return 'AddSensorRouteArgs{key: $key, onResult: $onResult, wizard: $wizard, url: $url}';
  }
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(DashboardRoute.name,
            path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [IntroductionPage]
class IntroductionRoute extends PageRouteInfo<IntroductionRouteArgs> {
  IntroductionRoute(
      {Key? key, required void Function(bool) onResult, int page = 1})
      : super(IntroductionRoute.name,
            path: '/introduction',
            args: IntroductionRouteArgs(
                key: key, onResult: onResult, page: page));

  static const String name = 'IntroductionRoute';
}

class IntroductionRouteArgs {
  const IntroductionRouteArgs(
      {this.key, required this.onResult, this.page = 1});

  final Key? key;

  final void Function(bool) onResult;

  final int page;

  @override
  String toString() {
    return 'IntroductionRouteArgs{key: $key, onResult: $onResult, page: $page}';
  }
}

/// generated route for
/// [IntroBetaPage]
class IntroBetaRoute extends PageRouteInfo<IntroBetaRouteArgs> {
  IntroBetaRoute(
      {Key? key,
      required void Function(bool) onResult,
      IntroBetaBloc? introBetaBloc})
      : super(IntroBetaRoute.name,
            path: '/intro-beta',
            args: IntroBetaRouteArgs(
                key: key, onResult: onResult, introBetaBloc: introBetaBloc));

  static const String name = 'IntroBetaRoute';
}

class IntroBetaRouteArgs {
  const IntroBetaRouteArgs(
      {this.key, required this.onResult, this.introBetaBloc});

  final Key? key;

  final void Function(bool) onResult;

  final IntroBetaBloc? introBetaBloc;

  @override
  String toString() {
    return 'IntroBetaRouteArgs{key: $key, onResult: $onResult, introBetaBloc: $introBetaBloc}';
  }
}

/// generated route for
/// [UrlUpdatePage]
class UrlUpdateRoute extends PageRouteInfo<UrlUpdateRouteArgs> {
  UrlUpdateRoute(
      {Key? key, required void Function(bool) onResult, bool wizard = true})
      : super(UrlUpdateRoute.name,
            path: '/url-update',
            args: UrlUpdateRouteArgs(
                key: key, onResult: onResult, wizard: wizard));

  static const String name = 'UrlUpdateRoute';
}

class UrlUpdateRouteArgs {
  const UrlUpdateRouteArgs(
      {this.key, required this.onResult, this.wizard = true});

  final Key? key;

  final void Function(bool) onResult;

  final bool wizard;

  @override
  String toString() {
    return 'UrlUpdateRouteArgs{key: $key, onResult: $onResult, wizard: $wizard}';
  }
}

/// generated route for
/// [AccountsPage]
class AccountsRoute extends PageRouteInfo<void> {
  const AccountsRoute() : super(AccountsRoute.name, path: 'accounts');

  static const String name = 'AccountsRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: 'home');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [HistoryPage]
class HistoryRoute extends PageRouteInfo<void> {
  const HistoryRoute() : super(HistoryRoute.name, path: 'history');

  static const String name = 'HistoryRoute';
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute() : super(SearchRoute.name, path: 'search');

  static const String name = 'SearchRoute';
}

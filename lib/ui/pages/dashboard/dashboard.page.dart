import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/dashboard/bloc/dashboard.bloc.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarColor: HomsaiColors.secondaryBlack,
      ),
      child: AutoTabsRouter(
        lazyLoad: false,
        routes: DashboardNavigation.values
            .map((tab) => dashboardTabRoutes[tab]!)
            .toList(),
        builder: (context, child, animation) {
          return HomsaiBlocScaffold(
            providers: [
              BlocProvider<DashboardBloc>(
                create: (BuildContext context) => DashboardBloc(),
              ),
              BlocProvider<HomeBloc>(
                create: (BuildContext context) => HomeBloc(),
              ),
            ],
            appBar: _dashboardAppBar(context),
            bottomNavigationBar: _DashboardBottomNavigationBar(
                tabsRouter: AutoTabsRouter.of(context)),
            mainAxisAlignment: MainAxisAlignment.center,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

AppBar _dashboardAppBar(context) {
  return AppBar(
      leading: _DashboardAppBarLeading(),
      title: _DashboardAppBarTitle(),
      actions: [
        _DashboardAppBarExitAction(),
      ]);
}

class _DashboardAppBarLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.help_outline_rounded,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}

class _DashboardAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(
          "casa andrea",
          style: Theme.of(context).textTheme.headline4,
        ),
        const Spacer(),
      ],
    );
  }
}

class _DashboardAppBarExitAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.exit_to_app_outlined,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}

class _DashboardBottomNavigationBar extends StatefulWidget {
  final TabsRouter tabsRouter;

  const _DashboardBottomNavigationBar({Key? key, required this.tabsRouter})
      : super(key: key);

  @override
  State<_DashboardBottomNavigationBar> createState() =>
      _DashboardBottomNavigationBarState();
}

class _DashboardBottomNavigationBarState
    extends State<_DashboardBottomNavigationBar> {
  Widget buildBottomBarIcons(
      BuildContext context, DashboardNavigation dashboardNavigation) {
    switch (dashboardNavigation) {
      case DashboardNavigation.home:
        return SvgPicture.asset(
          "assets/icons/logo.svg",
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          width: 20,
          height: 20,
        );
      case DashboardNavigation.history:
        return const Icon(Icons.history_rounded);
      case DashboardNavigation.search:
        return const Icon(Icons.search_rounded);
      case DashboardNavigation.accounts:
        return const Icon(Icons.manage_accounts_rounded);
    }
  }

  Widget? buildActiveBottomBarIcons(
      BuildContext context, DashboardNavigation dashboardNavigation) {
    switch (dashboardNavigation) {
      case DashboardNavigation.home:
        return SvgPicture.asset(
          "assets/icons/logo.svg",
          color: Theme.of(context).colorScheme.primary,
          width: 20,
          height: 20,
        );
      default:
        return null;
    }
  }

  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (var value in DashboardNavigation.values) {
      items.add(BottomNavigationBarItem(
          icon: buildBottomBarIcons(context, value),
          activeIcon: buildActiveBottomBarIcons(context, value),
          label: '',
          tooltip: ''));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Shadow(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: buildBottomNavigationBarItems(),
        currentIndex: widget.tabsRouter.activeIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: widget.tabsRouter.setActiveIndex,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 32,
      ),
      offset: const Offset(0, -5),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/ui/pages/dashboard/bloc/dashboard.bloc.dart';
import 'package:homsai/ui/widget/homsai_scaffold.widget.dart';
import 'package:homsai/ui/widget/shadow.widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: DashboardNavigation.values
          .map((tab) => dashboardTabRoutes[tab]!)
          .toList(),
      builder: (context, child, animation) {
        return HomsaiScaffold(
          providers: [
            BlocProvider<DashboardBloc>(
              create: (BuildContext context) => DashboardBloc(),
            ),
          ],
          appBar: DashboardAppBar(),
          bottomNavigationBar: _DashboardBottomNavigationBar(
              tabsRouter: AutoTabsRouter.of(context)),
          mainAxisAlignment: MainAxisAlignment.center,
          resizeToAvoidBottomInset: false,
          children: <Widget>[
            FadeTransition(
              opacity: animation,
              child: child,
            )
          ],
        );
      },
    );
  }
}

class DashboardAppBar extends AppBar {
  DashboardAppBar({Key? key})
      : super(
            key: key,
            leading: _DashboardAppBarLeading(),
            title: _DashboardAppBarTitle(),
            actions: [_DashboardAppBarExitAction()]);
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
  static final Map<DashboardNavigation, Widget Function(BuildContext)>
      _bottomBarIcons = {
    DashboardNavigation.home: (context) => SvgPicture.asset(
          "assets/icons/logo.svg",
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          width: 20,
          height: 20,
        ),
    DashboardNavigation.history: (context) => const Icon(Icons.history_rounded),
    DashboardNavigation.search: (context) => const Icon(Icons.search_rounded),
    DashboardNavigation.accounts: (context) =>
        const Icon(Icons.manage_accounts_rounded),
  };

  static final Map<DashboardNavigation, Widget Function(BuildContext)>
      _activeBottomBarIcons = {
    DashboardNavigation.home: (context) => SvgPicture.asset(
          "assets/icons/logo.svg",
          color: Theme.of(context).colorScheme.primary,
          width: 20,
          height: 20,
        ),
  };

  List<BottomNavigationBarItem> getItems() {
    List<BottomNavigationBarItem> items = [];
    for (var value in DashboardNavigation.values) {
      Widget? activeIcon;
      if (_activeBottomBarIcons.containsKey(value)) {
        activeIcon = _activeBottomBarIcons[value]!(context);
      }
      items.add(BottomNavigationBarItem(
          icon: _bottomBarIcons[value]!(context),
          activeIcon: activeIcon,
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
        items: getItems(),
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

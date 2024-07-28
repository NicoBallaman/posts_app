import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationManagerImpl implements NavigationManager {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _sectionNavigatorKey = GlobalKey<NavigatorState>();

  NavigationManagerImpl();

  @override
  void navigateTo<T>(BuildContext context, String route, {Object? arguments}) {
    context.go(route);
  }

  @override
  RouterConfig<Object> buildRoutes({required List<AppModule> modules}) {
    final routes = <AppRoute>[];
    for (final module in modules) {
      routes.addAll(module.generateRoutes());
    }
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/posts',
      routes: <RouteBase>[
        ..._convertAppRoutesToGoRoutes(routes.where((x) => x.routeType == RouteType.public).toList()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return navigationShell;
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _sectionNavigatorKey,
              routes: <RouteBase>[
                ..._convertAppRoutesToGoRoutes(routes.where((x) => x.routeType == RouteType.protected).toList()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<GoRoute> _convertAppRoutesToGoRoutes(List<AppRoute> appRoutes) {
    return appRoutes.map((appRoute) => _convertAppRouteToGoRoute(appRoute)).toList();
  }

  GoRoute _convertAppRouteToGoRoute(AppRoute appRoute) {
    return GoRoute(
      path: appRoute.path,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: appRoute.pageBuilder(state.pathParameters),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: appRoute.routes != null ? _convertAppRoutesToGoRoutes(appRoute.routes!) : [],
    );
  }
}

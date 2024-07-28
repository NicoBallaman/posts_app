import 'package:core/core.dart';
import 'package:flutter/material.dart';

abstract class NavigationManager {
  void navigateTo<T>(BuildContext context, String route);
  RouterConfig<Object> buildRoutes({required List<AppModule> modules});
}

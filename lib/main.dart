import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/ioc_manager.dart';
import 'package:posts_app/modules/posts_module/post_module.dart';
import 'application/application.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  final appModules = [
    PostModule(),
  ];
  IoCManager.registerDependencies(modules: appModules);

  final navigationManager = InjectorContainer.instance.resolve<NavigationManager>();
  final routes = navigationManager.buildRoutes(modules: appModules);

  runApp(Application(
    modules: appModules,
    routerConfig: routes,
  ));
}

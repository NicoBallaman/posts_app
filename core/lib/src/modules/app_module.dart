import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

abstract class AppModule {
  List<AppRoute> generateRoutes();
  FutureOr<void> registerDependencies(InjectorContainer injector);
  List<LocalizationsDelegate<dynamic>?> get localeDelegates;
}

import 'package:flutter/material.dart';

class AppRoute {
  final String path;
  final Widget Function(Map<String, String>? parameters) pageBuilder;
  final RouteType routeType;
  final List<AppRoute>? routes;

  AppRoute({
    required this.path,
    required this.pageBuilder,
    required this.routeType,
    this.routes,
  });
}

enum RouteType { public, protected }

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Application extends StatelessWidget {
  final RouterConfig<Object> _routerConfig;
  final List<AppModule> _modules;

  const Application({
    super.key,
    required List<AppModule> modules,
    required RouterConfig<Object> routerConfig,
  })  : _modules = modules,
        _routerConfig = routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _routerConfig,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ..._localizationDelegatesModules(),
      ],
      supportedLocales: SupportedLocales.appSupportedLanguages,
      debugShowCheckedModeBanner: false,
    );
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationDelegatesModules() {
    final delegates = <LocalizationsDelegate>[];
    delegates.add(CoreResolver().localeDelegate!);
    for (final module in _modules) {
      delegates.addAll(module.localeDelegates.whereType<LocalizationsDelegate<dynamic>>().toList());
    }
    return delegates;
  }
}

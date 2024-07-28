import 'package:core/core.dart';

abstract class IoCManager {
  static void registerDependencies({List<AppModule>? modules}) {
    final InjectorContainer injector = InjectorContainer.instance;

    CoreResolver().injectionModule!.registerDependencies(injector);

    if (modules != null) {
      for (final module in modules) {
        module.registerDependencies(injector);
      }
    }
  }
}

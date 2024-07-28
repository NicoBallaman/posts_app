import 'dart:async';
import 'package:core/core.dart';
import 'package:core/src/integrations/base_url_impl.dart';
import 'package:core/src/integrations/dio_http_manager.dart';
import 'package:core/src/integrations/navigation_manager_impl.dart';
import 'package:core/src/integrations/service_bus_impl.dart';

class CoreInjectionModule implements InjectionModule {
  @override
  FutureOr<void> registerDependencies(InjectorContainer injector) async {
    injector.registerFactory<HttpManager>(
      () => DioHttpManager(),
    );

    injector.registerLazySingleton<NavigationManager>(
      () => NavigationManagerImpl(),
    );

    injector.registerFactory<BaseUrl>(
      () => BaseUrlImpl(),
    );

    injector.registerLazySingleton<ServiceBus>(
      () => ServiceBusImpl(),
    );
  }
}

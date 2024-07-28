import 'package:core/src/integrations/get_it_injector_container.dart';

typedef FactoryFunc<T> = T Function();

abstract class InjectorContainer {
  static InjectorContainer instance = GetItInjector();

  void registerFactory<T extends Object>(FactoryFunc<T> factoryFunc);

  void registerFactoryByName<T extends Object>(FactoryFunc<T> factoryFunc, String name);

  void registerLazySingleton<T extends Object>(FactoryFunc<T> factoryFunc);

  T resolve<T extends Object>();

  T resolveByName<T extends Object>(String name);

  static InjectorContainer register() {
    instance = GetItInjector();
    return instance;
  }
}

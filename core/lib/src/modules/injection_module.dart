import 'dart:async';
import 'package:core/src/abstractions/injector_container.dart';

abstract class InjectionModule {
  FutureOr<void> registerDependencies(InjectorContainer injector);
}

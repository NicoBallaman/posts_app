import 'package:core/src/modules/injection_module.dart';
import 'package:flutter/material.dart';

abstract class FeatureResolver {
  InjectionModule? get injectionModule;
  LocalizationsDelegate? get localeDelegate;
}

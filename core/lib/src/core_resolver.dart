import 'package:core/core.dart';
import 'package:core/src/di/core_injection_module.dart';
import 'package:core/src/localization/core_localization.dart';
import 'package:flutter/material.dart';

class CoreResolver extends FeatureResolver {
  @override
  LocalizationsDelegate? get localeDelegate => coreLocalizationDelegate;

  @override
  InjectionModule? get injectionModule => CoreInjectionModule();
}

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:post_list/src/di/post_list_injection_module.dart';
import 'package:post_list/src/localization/post_list_localization.dart';

class PostListResolver extends FeatureResolver {
  @override
  LocalizationsDelegate? get localeDelegate => postListLocalizationDelegate;

  @override
  InjectionModule? get injectionModule => PostListInjectionModule();
}

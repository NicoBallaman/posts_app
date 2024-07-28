import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:post_comments/src/di/post_comments_injection_module.dart';
import 'package:post_comments/src/localization/post_comments_localization.dart';

class PostCommentsResolver extends FeatureResolver {
  @override
  LocalizationsDelegate? get localeDelegate => postCommentsLocalizationDelegate;

  @override
  InjectionModule? get injectionModule => PostCommentsInjectionModule();
}

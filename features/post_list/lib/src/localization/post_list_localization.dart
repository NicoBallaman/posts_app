import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

final postListLocalizationDelegate = PostListLocalizationDelegate(
  getPathFunction: (locale) => getTransalationFilePath(packageName: 'post_list', locale: locale),
  supportedLocales: SupportedLocales.appSupportedLanguages,
);

class PostListLocalization extends BaseLocalization {
  PostListLocalization({
    required this.appLocale,
    required this.appPathFunction,
  }) : super(appPathFunction: appPathFunction, locale: appLocale);
  @override
  // ignore: overridden_fields
  final String Function(Locale locale) appPathFunction;
  final Locale appLocale;

  static PostListLocalization of(BuildContext context) => Localizations.of<PostListLocalization>(context, PostListLocalization)!;
}

class PostListLocalizationDelegate extends LocalizationsDelegate<PostListLocalization> {
  PostListLocalizationDelegate({required this.supportedLocales, required this.getPathFunction});

  final List<Locale> supportedLocales;

  final String Function(Locale locale) getPathFunction;

  late Locale locale;

  @override
  bool isSupported(Locale locale) => getSupportedLocaleForLanguageCode(supportedLocales, locale) != null;

  @override
  Future<PostListLocalization> load(Locale locale) async {
    this.locale = locale;
    final localization = PostListLocalization(appLocale: locale, appPathFunction: getPathFunction);

    await localization.load();

    return localization;
  }

  @override
  bool shouldReload(PostListLocalizationDelegate old) => old.locale != locale;
}

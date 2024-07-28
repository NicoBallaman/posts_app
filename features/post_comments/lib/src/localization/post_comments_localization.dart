import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

final postCommentsLocalizationDelegate = PostCommentsLocalizationDelegate(
  getPathFunction: (locale) => getTransalationFilePath(packageName: 'post_comments', locale: locale),
  supportedLocales: SupportedLocales.appSupportedLanguages,
);

class PostCommentsLocalization extends BaseLocalization {
  PostCommentsLocalization({
    required this.appLocale,
    required this.appPathFunction,
  }) : super(appPathFunction: appPathFunction, locale: appLocale);
  @override
  // ignore: overridden_fields
  final String Function(Locale locale) appPathFunction;
  final Locale appLocale;

  static PostCommentsLocalization of(BuildContext context) => Localizations.of<PostCommentsLocalization>(context, PostCommentsLocalization)!;
}

class PostCommentsLocalizationDelegate extends LocalizationsDelegate<PostCommentsLocalization> {
  PostCommentsLocalizationDelegate({required this.supportedLocales, required this.getPathFunction});

  final List<Locale> supportedLocales;

  final String Function(Locale locale) getPathFunction;

  late Locale locale;

  @override
  bool isSupported(Locale locale) => getSupportedLocaleForLanguageCode(supportedLocales, locale) != null;

  @override
  Future<PostCommentsLocalization> load(Locale locale) async {
    this.locale = locale;
    final localization = PostCommentsLocalization(appLocale: locale, appPathFunction: getPathFunction);

    await localization.load();

    return localization;
  }

  @override
  bool shouldReload(PostCommentsLocalizationDelegate old) => old.locale != locale;
}

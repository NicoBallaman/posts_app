import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

final coreLocalizationDelegate = CoreLocalizationDelegate(
  getPathFunction: (locale) => getTransalationFilePath(packageName: 'core', locale: locale),
  supportedLocales: SupportedLocales.appSupportedLanguages,
);

class CoreLocalization extends BaseLocalization {
  CoreLocalization({
    required this.appLocale,
    required this.appPathFunction,
  }) : super(appPathFunction: appPathFunction, locale: appLocale);
  @override
  // ignore: overridden_fields
  final String Function(Locale locale) appPathFunction;
  final Locale appLocale;

  static CoreLocalization of(BuildContext context) => Localizations.of<CoreLocalization>(context, CoreLocalization)!;
}

class CoreLocalizationDelegate extends LocalizationsDelegate<CoreLocalization> {
  CoreLocalizationDelegate({required this.supportedLocales, required this.getPathFunction});

  final List<Locale> supportedLocales;

  final String Function(Locale locale) getPathFunction;

  late Locale locale;

  @override
  bool isSupported(Locale locale) => getSupportedLocaleForLanguageCode(supportedLocales, locale) != null;

  @override
  Future<CoreLocalization> load(Locale locale) async {
    this.locale = locale;
    final localization = CoreLocalization(appLocale: locale, appPathFunction: getPathFunction);

    await localization.load();

    return localization;
  }

  @override
  bool shouldReload(CoreLocalizationDelegate old) => old.locale != locale;
}

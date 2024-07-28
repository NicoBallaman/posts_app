import 'dart:collection';
import 'dart:convert';

import 'package:core/src/utils/json_flat.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Base class to create a Locale Delegate
class BaseLocalization {
  final Locale locale;

  final String Function(Locale locale) appPathFunction;

  final Map<String, dynamic> _strings = HashMap();

  BaseLocalization({
    required this.locale,
    required this.appPathFunction,
  });

  static BaseLocalization of(BuildContext context) => Localizations.of<BaseLocalization>(context, BaseLocalization)!;

  /// Initialize the locale-specific strings.
  /// It searchs for a string file in the
  /// provided appPathFunction and set them into the Intl.defaultLocale.
  Future<void> load() async {
    try {
      final data = await rootBundle.loadString(appPathFunction(locale));
      final Map<String, dynamic> strings = json.decode(data);
      final flattenedStrings = JsonFlat.flatten(strings);
      _strings.addAll(flattenedStrings);

      final localeName = locale.countryCode?.isEmpty == null ? locale.languageCode : locale.toString();
      final canonicalLocaleName = Intl.canonicalizedLocale(localeName);
      Intl.defaultLocale = canonicalLocaleName;
    } catch (_, __) {
      //print(exception);
    }
  }

  /// Translate a given key to the current locale.
  /// You may also use the values and pluralCount
  /// to add more parameters to the translation.
  String translate(String key, {Map<String, String>? values}) {
    final String? message = _loadMessage(key);

    if (message == null) {
      return key;
    }

    if (values != null) {
      return _formatReturnMessage(message, values);
    }

    return message;
  }

  String? _loadMessage(String key) {
    final value = _strings[key];

    if (value == null || (value is! String)) {
      return null;
    }

    return value;
  }

  String _formatReturnMessage(String value, Map<String, String> arguments) {
    String formatedValue = value;
    arguments.forEach(
      (formatKey, formatValue) => formatedValue = value.replaceAll('{$formatKey}', formatValue),
    );
    return formatedValue;
  }
}

import 'package:core/src/abstractions/base_url.dart';

class BaseUrlImpl implements BaseUrl {
  @override
  String get value => const String.fromEnvironment("BASE_URL", defaultValue: "");
}

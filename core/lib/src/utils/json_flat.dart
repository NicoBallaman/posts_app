abstract class JsonFlat {
  static Map<String, dynamic> flatten(Map<String, dynamic> target, {String delimiter = ".", bool safe = false, int? maxDepth}) {
    final result = <String, dynamic>{};

    void step(
      Map<String, dynamic> obj, [
      String? previousKey,
      int currentDepth = 1,
    ]) {
      obj.forEach((key, value) {
        final newKey = previousKey != null ? "$previousKey$delimiter$key" : key;

        if (maxDepth != null && currentDepth >= maxDepth) {
          result[newKey] = value;
          return;
        }
        if (value is Map<String, dynamic>) {
          return step(value, newKey, currentDepth + 1);
        }
        if (value is List && !safe) {
          return step(
            _listToMap(value),
            newKey,
            currentDepth + 1,
          );
        }
        result[newKey] = value;
      });
    }

    step(target);

    return result;
  }

  static Map<String, T> _listToMap<T>(List<T> list) => list.asMap().map((key, value) => MapEntry(key.toString(), value));
}

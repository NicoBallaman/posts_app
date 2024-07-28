abstract class HttpManager {
  Future<HttpResponse<T>> get<T>(String url, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers});

  Future<HttpResponse<T>> post<T>(String url, {dynamic data, Map<String, dynamic>? headers});

  Future<HttpResponse<T>> put<T>(String url, {dynamic data, Map<String, dynamic>? headers});
}

class HttpResponse<T> {
  final T data;
  final int statusCode;
  final String? createdId;
  final String? error;

  HttpResponse({
    required this.data,
    required this.statusCode,
    this.createdId,
    this.error,
  });

  bool isOk() {
    return statusCode >= 200 && statusCode <= 304;
  }
}

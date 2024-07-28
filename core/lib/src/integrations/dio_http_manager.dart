import 'package:core/src/abstractions/http_manager.dart';
import 'package:dio/dio.dart';

class DioHttpManager implements HttpManager {
  final Dio _dioInstance;

  DioHttpManager() : _dioInstance = Dio();

  @override
  Future<HttpResponse<T>> get<T>(String url, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    await _buildDio(headers);
    var response = await _dioInstance.get(url, queryParameters: queryParameters);
    final createdResourceId = _getCreatedResourceId(response);
    final error = _getErrorMessage(response.statusCode, response.data);
    return HttpResponse(data: response.data, statusCode: response.statusCode!, createdId: createdResourceId, error: error);
  }

  @override
  Future<HttpResponse<T>> post<T>(String url, {data, Map<String, dynamic>? headers}) async {
    await _buildDio(headers);
    var response = await _dioInstance.post(url, data: data);
    final createdResourceId = _getCreatedResourceId(response);
    final error = _getErrorMessage(response.statusCode, response.data);
    return HttpResponse(data: response.data, statusCode: response.statusCode!, createdId: createdResourceId, error: error);
  }

  @override
  Future<HttpResponse<T>> put<T>(String url, {data, Map<String, dynamic>? headers}) async {
    await _buildDio(headers);
    var response = await _dioInstance.put(url, data: data);
    final createdResourceId = _getCreatedResourceId(response);
    final error = _getErrorMessage(response.statusCode, response.data);
    return HttpResponse(data: response.data, statusCode: response.statusCode!, createdId: createdResourceId, error: error);
  }

  Future<void> _buildDio(Map<String, dynamic>? headers) async {
    _dioInstance.options.headers.addAll(
      {
        'Accept': 'application/json',
      },
    );
    if (headers != null) _dioInstance.options.headers.addAll(headers);

    _dioInstance.options.validateStatus = (status) => status! < 500;
    return Future.value();
  }

  String? _getCreatedResourceId(Response response) {
    if (response.headers.isEmpty) {
      return null;
    }

    final locationValue = response.headers.map['location'];
    if (locationValue == null || locationValue.isEmpty) {
      return null;
    }

    final resourceId = _getLastPathSegment(locationValue.first);
    return resourceId;
  }

  String? _getLastPathSegment(String url) {
    final RegExp regex = RegExp(r'/(\w+)/?$');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  String? _getErrorMessage(int? statusCode, dynamic decodedBody) {
    if (statusCode != null && statusCode >= 200 && statusCode <= 304) {
      return null;
    }
    if (decodedBody == null || decodedBody is! Map) {
      return null;
    }
    decodedBody = decodedBody.containsKey('apierror') ? decodedBody['apierror'] : decodedBody;

    if (decodedBody.containsKey('subErrors')) {
      final String? subErrorMessage = _getFirstSubrrorMessage(decodedBody['subErrors']);
      if (subErrorMessage != null) {
        return subErrorMessage;
      }
    }
    if (decodedBody.containsKey('message')) {
      return decodedBody['message'];
    }
    if (decodedBody.containsKey('error')) {
      return decodedBody['error'];
    }
    return '$statusCode - Unknow error';
  }

  String? _getFirstSubrrorMessage(dynamic subErrors) {
    String errorMessage = '';
    if (subErrors.length <= 0) {
      return null;
    }
    subErrors = subErrors[0];
    //errorMessage += subErrors.containsKey('field') ? '${subErrors['field']} ' : '';
    errorMessage += subErrors.containsKey('message') ? subErrors['message'] : '';
    return errorMessage;
  }
}

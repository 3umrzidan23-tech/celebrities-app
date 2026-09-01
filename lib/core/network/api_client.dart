import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.connectTimeout = const Duration(seconds: 15);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters['api_key'] = ApiConstants.apiKey;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
    // Optional: Add logging interceptor for debug mode
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }
}

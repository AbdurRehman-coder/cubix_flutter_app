import 'dart:developer';
import 'package:cubix_app/core/services/api_config.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() : dio = Dio() {
    dio.options.baseUrl = ApiConfig.baseUrl;

    dio.options.connectTimeout = Duration(milliseconds: 300000);
    dio.options.receiveTimeout = Duration(milliseconds: 300000);
    dio.options.responseType = ResponseType.json;

    // Add token interceptor
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = SharedPrefServices();
          final token = await prefs.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options); // Continue with request
        },
      ),
    );

    ///with token and logger
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log('⚠️ Token expired. Attempting to refresh...');

      try {
        ///
        /// handle refresh token
      } catch (e) {
        log('❌ Failed to refresh token: $e');
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }

  Future<Response> _retryRequest(RequestOptions requestOptions, String? token) {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

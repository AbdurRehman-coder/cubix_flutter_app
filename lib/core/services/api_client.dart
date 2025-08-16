import 'dart:developer';
import 'package:cubix_app/core/services/api_config.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() : dio = Dio() {
    dio.options.baseUrl = ApiConfig.baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 1200000);
    dio.options.receiveTimeout = const Duration(milliseconds: 1200000);
    dio.options.responseType = ResponseType.json;

    final prefs = SharedPrefServices();
    final authServices = AuthServices(
      apiClient: this,
      googleAuthService: GoogleAuthService(),
      appleAuthServices: AppleAuthServices(),
      localDBServices: prefs,
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await prefs.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      TokenInterceptor(
        dio: dio,
        authServices: authServices,
        localDBServices: prefs,
      ),
    );

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
  final AuthServices authServices;
  final SharedPrefServices localDBServices;

  TokenInterceptor({
    required this.dio,
    required this.authServices,
    required this.localDBServices,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log('⚠️ Access token expired. Refreshing...');

      try {
        final newAuth = await authServices.handleRefreshToken();
        if (newAuth != null) {
          final newToken = newAuth.accessToken;
          final clonedRequest = await _retryRequest(
            err.requestOptions,
            newToken,
          );
          return handler.resolve(clonedRequest);
        }
      } catch (e) {
        log('❌ Token refresh failed: $e');
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

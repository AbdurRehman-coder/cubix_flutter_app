import 'dart:developer';
import 'package:cubix_app/core/services/api_config.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio dio;
  final prefs = SharedPrefServices();

  ApiClient() : dio = Dio() {
    dio.options
      ..baseUrl = ApiConfig.baseUrl
      ..connectTimeout = const Duration(milliseconds: 1200000)
      ..receiveTimeout = const Duration(milliseconds: 1200000)
      ..responseType = ResponseType.json;

    // Attach access token
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = await prefs.getLoggedUser();
          if (user?.accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${user!.accessToken}';
          }
          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(TokenInterceptor(dio, prefs));

    // Logging
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final SharedPrefServices prefs;
  bool _isRefreshing = false;

  TokenInterceptor(this.dio, this.prefs);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || _isRefreshing) {
      return super.onError(err, handler);
    }

    _isRefreshing = true;
    log('⚠️ Access token expired. Refreshing...');

    try {
      final user = await prefs.getLoggedUser();
      if (user?.refreshToken == null) return super.onError(err, handler);

      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl))
        ..options.headers['Authorization'] = 'Bearer ${user!.refreshToken}';

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {"appVersion": AppUtils.getAppVersion()},
      );
      log('🔄 Refresh response: ${response.data}');

      final updatedUser = user.copyWith(
        accessToken: response.data['body']['accessToken'] as String,
        refreshToken: response.data['body']['refreshToken'] as String,
      );

      await prefs.saveLoggedUser(updatedUser);
      dio.options.headers['Authorization'] =
          'Bearer ${updatedUser.accessToken}';

      final retryResponse = await _retryRequest(
        err.requestOptions,
        updatedUser.accessToken,
      );
      return handler.resolve(retryResponse);
    } catch (e) {
      log('❌ Refresh token failed: $e');
      return super.onError(err, handler);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retryRequest(RequestOptions req, String token) {
    return dio.request(
      req.path,
      data: req.data,
      queryParameters: req.queryParameters,
      options: Options(
        method: req.method,
        headers: {...req.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }
}

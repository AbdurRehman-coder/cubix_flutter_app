import 'dart:developer';
import 'package:cubix_app/core/services/api_config.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio dio;
  final SharedPrefServices prefs = SharedPrefServices();
  late final AuthServices authServices;

  ApiClient() : dio = Dio() {
    dio.options
      ..baseUrl = ApiConfig.baseUrl
      ..connectTimeout = const Duration(milliseconds: 1200000)
      ..receiveTimeout = const Duration(milliseconds: 1200000)
      ..responseType = ResponseType.json;

    authServices = AuthServices(
      apiClient: this,
      googleAuthService: GoogleAuthService(),
      appleAuthServices: AppleAuthServices(),
      localDBServices: prefs,
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // ✅ Attach access token normally
          final loggedUser = await prefs.getLoggedUser();
          if (loggedUser?.accessToken != null) {
            options.headers['Authorization'] =
                'Bearer ${loggedUser!.accessToken}';
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

  bool _isRefreshing = false;
  final List<Function(Response)> _retryQueue = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      log('⚠️ Access token expired. Refreshing...');

      try {
        final loggedUser = await localDBServices.getLoggedUser();
        if (loggedUser?.refreshToken == null) {
          return super.onError(err, handler);
        }

        // ✅ Use refresh token explicitly for refresh call
        final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
        refreshDio.options.headers['Authorization'] =
            'Bearer ${loggedUser!.refreshToken}';

        final newAuth = await authServices.handleRefreshToken();
        if (newAuth != null) {
          await localDBServices.saveLoggedUser(newAuth);
          dio.options.headers['Authorization'] =
              'Bearer ${newAuth.accessToken}';

          // retry queued requests
          for (var callback in _retryQueue) {
            callback(
              await _retryRequest(err.requestOptions, newAuth.accessToken),
            );
          }
          _retryQueue.clear();
          _isRefreshing = false;

          // retry the failed request itself
          final retryResponse = await _retryRequest(
            err.requestOptions,
            newAuth.accessToken,
          );
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        log('❌ Token refresh failed: $e');
      } finally {
        _isRefreshing = false;
      }
    }

    return super.onError(err, handler);
  }

  Future<Response> _retryRequest(RequestOptions requestOptions, String token) {
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

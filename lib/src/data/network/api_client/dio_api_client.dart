import 'dart:io';

import 'package:xander9112/xander9112.dart';

/// Клиент для работы с Dio
/// final dioApiClient = DioApiClient(Uri.parse('https://sise.com'), connectTimeout: Duration(seconds: 20), useLogger: kDebugMode);
///
/// dioApiClient.addInterceptor(DeviceHeaderInterceptor());
///
/// dioApiClient.addInterceptor(AuthInterceptor(sl()));
/// dioApiClient.addInterceptor(LogoutInterceptor());
///
/// dioApiClient.addHeaders({HttpHeaders.acceptHeader: ContentType.text});
class DioApiClient {
  DioApiClient(
    Uri uri, {
    Dio? dio,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    this.useLogger = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
  })  : _dio = dio ?? Dio(),
        _connectTimeout = connectTimeout ?? const Duration(seconds: 50),
        _receiveTimeout = receiveTimeout ?? const Duration(seconds: 50) {
    _init(uri);
  }

  final Dio _dio;
  final bool useLogger;

  final Duration _connectTimeout;
  final Duration _receiveTimeout;

  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  CancelToken cancelToken = CancelToken();

  Dio get dio => _dio;

  set newBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  String get newBaseUrl {
    return _dio.options.baseUrl;
  }

  Map<String, String> get headers {
    return Map.castFrom<String, dynamic, String, String>(_dio.options.headers);
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void addHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  void _init(Uri baseUrl) {
    _initBaseOptions(baseUrl);

    _initInterceptors();
  }

  void _initBaseOptions(Uri baseUrl) {
    _dio.options.baseUrl = baseUrl.toString();

    _dio.options.connectTimeout = _connectTimeout;
    _dio.options.receiveTimeout = _receiveTimeout;

    addHeaders({HttpHeaders.acceptHeader: ContentType.json.value});

    _dio.options.responseType = ResponseType.json;
  }

  void _initInterceptors() {
    if (useLogger) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: requestHeader,
          requestBody: requestBody,
          responseHeader: responseHeader,
          responseBody: responseBody,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
      // logoutInterceptor.cancelToken = cancelToken;
    }

    options.cancelToken = cancelToken;

    return handler.next(options);
  }

  Future<void> _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // ignore: avoid_dynamic_calls
    if (response.data.runtimeType != String) {
      // ignore: avoid_dynamic_calls
      if (response.data != null && response.data['data'] != null) {
        // ignore: avoid_dynamic_calls
        response.data = response.data['data'];
      }
    }

    return handler.next(response);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
    // late DioException error;

    // if (e.response == null && e.error is SocketException) {
    //   error = DioNetworkError(
    //     requestOptions: e.requestOptions,
    //     type: e.type,
    //     error: e.error,
    //     response: e.response,
    //   );
    // } else if (e.type == DioExceptionType.connectionTimeout ||
    //     e.type == DioExceptionType.receiveTimeout ||
    //     e.type == DioExceptionType.sendTimeout) {
    //   error = DioConnectTimeoutError(
    //     requestOptions: e.requestOptions,
    //     type: e.type,
    //     error: e.error,
    //     response: e.response,
    //   );
    // } else if (e.type == DioExceptionType.unknown) {
    //   error = DioConnectTimeoutError(
    //     requestOptions: e.requestOptions,
    //     type: e.type,
    //     error: e.error,
    //     response: e.response,
    //   );
    // } else if (e.type == DioExceptionType.cancel) {
    //   error = DioCancelError(
    //     requestOptions: e.requestOptions,
    //     type: e.type,
    //     error: e.error,
    //     response: e.response,
    //   );
    // } else {
    //   error = e;
    // }

    return handler.next(e);
  }
}

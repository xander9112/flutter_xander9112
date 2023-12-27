import 'package:xander9112/xander9112.dart';

class DeviceHeaderInterceptor extends Interceptor {
  DeviceHeaderInterceptor();

  CancelToken? cancelToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final appInfo = await AppInfo.getAppInfo();
    final deviceInfo = await AppInfo.getDeviceInfo();

    options.headers.addAll(<String, String>{
      'X-Device-System': deviceInfo.system,
      'X-Device-Model': deviceInfo.model.replaceAll('‘', '_'),
      'X-Device-Version': deviceInfo.version,
      'X-Application-Version': appInfo.version,
      'X-Application-Build': appInfo.buildNumber,
    });

    return super.onRequest(options, handler);
  }
}

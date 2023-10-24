import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xander9112/xander9112.dart';

abstract class AppInfo {
  static Future<String?> _getId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      final iosDeviceInfo = await deviceInfo.iosInfo;

      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }

    return null;
  }

  static Future<DeviceInfoModel> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      final WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      final UserAgentParser parser = UserAgentParser();
      final Result result = parser.parseResult(webBrowserInfo.userAgent ?? '');

      return DeviceInfoModel(
        model: result.browser?.name ?? '',
        system: webBrowserInfo.platform ?? '',
        version: result.browser?.version ?? '',
      );
    }

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return DeviceInfoModel(
        model: '${androidInfo.brand} ${androidInfo.model}',
        system: 'Android',
        version: androidInfo.version.release,
      );
    }

    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return DeviceInfoModel(
        model: iosInfo.name,
        system: iosInfo.systemName,
        version: iosInfo.systemVersion,
      );
    }

    return const DeviceInfoModel(
      model: '',
      system: '',
      version: '',
    );
  }

  static Future<AppInfoModel> getAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final String appName = packageInfo.appName;
    final String packageName = packageInfo.packageName;
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;

    return AppInfoModel(
      appName: appName,
      packageName: packageName,
      version: version.replaceAll('-dev', ''),
      buildNumber: buildNumber,
    );
  }
}
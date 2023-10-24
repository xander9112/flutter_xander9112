import 'package:xander9112/xander9112.dart';

extension DioExceptionLog on DioException {
  String get errorMessage {
    String msg =
        'Type: $type, Message: ${message ?? error}, url: ${requestOptions.uri}';

    if (response?.data != null) {
      msg += ', ${response!.data}';
    }

    return msg;
  }

  String get errorResponseMessage {
    try {
      // ignore: avoid_dynamic_calls
      return response?.data['message'] as String;
    } catch (_) {
      return errorMessage;
    }
  }

  int get errorResponseCode => response?.statusCode ?? -1;
}

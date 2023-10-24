import 'package:xander9112/xander9112.dart';

class HttpFailure extends Failure {
  HttpFailure(this.httpCode, {required super.code, super.message});

  final HttpCodes httpCode;

  @override
  String getLocalizedString() {
    return 'Unknown error';
  }
}

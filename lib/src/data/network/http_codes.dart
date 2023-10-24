enum HttpCodes {
  unknown(0),
  internalError(500),
  forbidden(403),
  notFound(404),
  serviceUnavailable(503);

  const HttpCodes(this.code);
  final int code;

  String getLocalizedString() {
    switch (this) {
      case HttpCodes.internalError:
        return 'internalError';
      case HttpCodes.forbidden:
        return 'forbiddenError';
      case HttpCodes.serviceUnavailable:
        return 'serviceUnavailableError';
      case HttpCodes.notFound:
        return 'notFoundError';
      case HttpCodes.unknown:
        return 'unknownError';
    }
  }
}

abstract class Failure {
  Failure({required this.code, this.message});

  final dynamic code;
  final String? message;

  String getLocalizedString();
}

abstract class Failure {
  Failure({required this.code, this.message});

  final int code;
  final String? message;

  String getLocalizedString();
}

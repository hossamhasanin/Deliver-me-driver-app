class AuthException implements Exception{
  final String code;
  final String? message;

  AuthException(this.code, this.message);
}
class AuthUnauthorizedException implements Exception {}

class AuthUnprocessableEntityException implements Exception {
  final String message;
  AuthUnprocessableEntityException(this.message);
}

class AuthInternalErrorException implements Exception {
  final String message;
  AuthInternalErrorException(this.message);
}

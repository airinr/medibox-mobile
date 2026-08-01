class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized', statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException() : super('Not found', statusCode: 404);
}

class ServerException extends ApiException {
  ServerException() : super('Internal server error', statusCode: 500);
}

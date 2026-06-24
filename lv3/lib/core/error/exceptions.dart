/// Exception ở tầng data. Mang theo message + status từ server để ánh xạ thành một Failure.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

/// Failure ở tầng domain. UI/controllers sử dụng lớp này, không bao giờ dùng exception thô.
class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class AppException implements Exception {
  final String message;
  final String prefix;

  AppException({required this.message, required this.prefix});

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(
            message: message ?? "Unknown Error",
            prefix: "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(
            message: message ?? "Invalid Request", prefix: "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(
            message: message ?? "Unauthorised Request",
            prefix: "Unauthorised Request: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message: message ?? "Invalid Input", prefix: "Invalid Input: ");
}

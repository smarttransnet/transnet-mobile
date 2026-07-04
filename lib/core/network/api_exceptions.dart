import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.data}) : super(statusCode: 401);
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode, super.data});
}

class TimeoutException extends ApiException {
  TimeoutException(super.message) : super(statusCode: 408);
}

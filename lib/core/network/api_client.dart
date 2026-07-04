import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_exceptions.dart';
import '../storage/secure_storage_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class ApiClient {
  final Ref _ref;
  late final Dio _dio;

  static String get _baseUrl {
    if (kReleaseMode) {
      return 'http://transnet-api-alb-918364473.ap-southeast-1.elb.amazonaws.com/';
    }
    
    if (kIsWeb) {
      return 'http://localhost:5000/';
    } else if (Platform.isAndroid) {
      // 192.168.1.203 is your computer's local IP address on the Wi-Fi network.
      // This allows a physical Android device on the same Wi-Fi to connect to the backend.
      // (If you switch back to an Emulator later, you can use 'http://10.0.2.2:5000/')
      return 'http://192.168.1.203:5000/';
    } else {
      // iOS simulator and desktop apps share the host machine's network
      return 'http://localhost:5000/';
    }
  }

  ApiClient(this._ref) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Inject token if available
          final secureStorage = _ref.read(secureStorageServiceProvider);
          final token = await secureStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(_handleError(e));
        },
      ),
    );
  }

  Dio get dio => _dio;

  DioException _handleError(DioException error) {
    String message = 'An unexpected error occurred';
    if (error.response?.data != null) {
      if (error.response!.data is Map && error.response!.data.containsKey('title')) {
        message = error.response!.data['title'];
      } else {
        message = error.response!.data.toString();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      throw TimeoutException('Connection timed out. Please try again.');
    }

    if (error.type == DioExceptionType.connectionError || error.error is SocketException) {
      throw NetworkException('No internet connection. Please check your network.');
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedException('Invalid username or password.');
    }

    if (statusCode != null && statusCode >= 500) {
      throw ServerException('Server error. Please try again later.', statusCode: statusCode);
    }

    throw ApiException(message, statusCode: statusCode, data: error.response?.data);
  }
}

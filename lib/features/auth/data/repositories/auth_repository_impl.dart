import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_api_client.dart';
import '../models/login_request.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiClient: ref.read(authApiClientProvider),
    storageService: ref.read(secureStorageServiceProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepositoryImpl({
    required AuthApiClient apiClient,
    required SecureStorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequest(
      email: username,
      password: password,
    );

    final response = await _apiClient.login(request);

    // Save tokens securely
    await _storageService.saveAuthData(
      accessToken: response.token,
      userId: response.userId,
    );
  }

  @override
  Future<void> logout() async {
    await _storageService.clearAuthData();
  }
}

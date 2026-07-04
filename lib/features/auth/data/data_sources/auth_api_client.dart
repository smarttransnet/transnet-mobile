import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

final authApiClientProvider = Provider<AuthApiClient>((ref) {
  return AuthApiClient(ref.read(apiClientProvider));
});

class AuthApiClient {
  final ApiClient _apiClient;

  AuthApiClient(this._apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      'users/login',
      data: request.toJson(),
    );

    // Assuming the API returns the result either wrapped in a value object or directly
    // based on `result.Match(Results.Ok, CustomResults.Problem)` in ASP.NET Minimal APIs.
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      return LoginResponse.fromJson(data['value']);
    }
    return LoginResponse.fromJson(data);
  }
}

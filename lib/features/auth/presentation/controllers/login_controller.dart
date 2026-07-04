import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(() {
  return LoginController();
});

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.login(username: username, password: password);
      
      // Invalidate the authStateProvider so GoRouter knows the user is logged in
      ref.invalidate(authStateProvider);
      
      state = state.copyWith(status: LoginStatus.success);
      return true;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        final apiException = e.error as ApiException;
        state = state.copyWith(status: LoginStatus.error, errorMessage: apiException.message);
      } else {
        state = state.copyWith(status: LoginStatus.error, errorMessage: 'Network error: ${e.message}');
      }
      return false;
    } catch (e, st) {
      print('Unexpected error: $e\n$st');
      state = state.copyWith(status: LoginStatus.error, errorMessage: 'Unexpected: $e');
      return false;
    }
  }
}


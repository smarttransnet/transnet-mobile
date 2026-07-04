import 'package:equatable/equatable.dart';

enum LoginStatus { idle, loading, success, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.idle,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage, // Setting this to null when status changes explicitly handled in controller
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

enum Status { initial, loading, success, error }

class LoginState {
  final Status status;
  final String? message;
  const LoginState({required this.status, this.message});

  LoginState copyWith({Status? status, String? message}) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
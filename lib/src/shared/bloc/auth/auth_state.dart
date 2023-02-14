part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final bool loading;
  final String message;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.loading = false,
    this.message = '',
  });

  const AuthState.unknown() : this._();

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated, user: null);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? loading,
    String? message,
  }) {
    return AuthState._(
      status: status ?? this.status,
      user: user ?? this.user,
      loading: loading ?? this.loading,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, loading, message];
}

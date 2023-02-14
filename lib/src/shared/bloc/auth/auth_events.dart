part of 'auth_bloc.dart';

abstract class AuthEvents extends Equatable {
  const AuthEvents();

  @override
  List<Object?> get props => [];
}

class _AuthStatusChanged extends AuthEvents {
  final AuthStatus status;

  const _AuthStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class AuthLogoutRequested extends AuthEvents {
  const AuthLogoutRequested();
}

class AuthLoginRequested extends AuthEvents {
  final String email;
  final String password;

  const AuthLoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvents {
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequested(this.name, this.email, this.password);

  @override
  List<Object?> get props => [name, email, password];
}

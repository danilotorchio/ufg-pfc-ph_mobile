import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/auth_repository.dart';
import '../../utils/exceptions/auth_exceptions.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthRepository _repository = AuthRepository();

  AuthBloc() : super(const AuthState.unknown()) {
    _configureEvents();
  }

  void _configureEvents() {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
  }

  @override
  Future<void> close() {
    _repository.dispose();

    return super.close();
  }

  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthStatus.authenticated:
        final user = _repository.user;

        return emit(user == null
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(user));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _repository.logout();
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      await _repository.login(event.email, event.password);
    } on Exception catch (e) {
      _errorHandler(e);
    }

    emit(state.copyWith(loading: false));
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      await _repository.register(event.name, event.email, event.password);
    } on Exception catch (e) {
      _errorHandler(e);
    }

    emit(state.copyWith(loading: false));
  }

  void _errorHandler(Exception e) {
    if (e is AuthUnauthorizedException) {
      // TODO: handle AuthUnauthorizedException
    } else if (e is AuthUnprocessableEntityException) {
      // TODO: handle AuthUnprocessableEntityException
    } else if (e is AuthInternalErrorException) {
      // TODO: handle AuthInternalErrorException
    } else {
      // TODO: handle Exception
    }
  }
}

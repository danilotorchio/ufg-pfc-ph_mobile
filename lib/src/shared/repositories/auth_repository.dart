import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils/exceptions/auth_exceptions.dart';

String _defaultErrorMessage = 'Ocorreu um erro ao processar sua solicitação.';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthRepository {
  FirebaseAuth get _fba => FirebaseAuth.instance;
  User? get user => _fba.currentUser;

  late StreamSubscription<User?> _fbaUserSub;
  final _controller = StreamController<AuthStatus>();

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unknown;
    yield* _controller.stream;
  }

  AuthRepository() {
    // Atraso para permanecer no splash por 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      _fbaUserSub = _fba.authStateChanges().listen((user) {
        _controller.add(user == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated);
      });
    });
  }

  void dispose() {
    _fbaUserSub.cancel();
    _controller.close();
  }

  logout() {
    _fba.signOut();
  }

  Future<void> login(String email, String password) async {
    try {
      await _fba.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        log('Wrong user/password provided.');
        throw AuthUnauthorizedException();
      }

      log('Internal server error: $e');
      throw AuthInternalErrorException(_defaultErrorMessage);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final res = await _fba.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        await res.user?.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log('E-mail already in use.');
        throw AuthUnprocessableEntityException(
          'O e-mail informado já está cadastrado.',
        );
      }

      log('Internal server error: $e');
      throw AuthInternalErrorException(_defaultErrorMessage);
    }
  }
}

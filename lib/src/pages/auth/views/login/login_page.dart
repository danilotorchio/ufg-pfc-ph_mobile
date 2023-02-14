import 'package:flutter/material.dart';

import 'login_view.dart';

class LoginPage extends StatelessWidget {
  static String route = '/auth/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

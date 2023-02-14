import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

class SplashPage extends StatelessWidget {
  static String route = '/';
  final String _logo = 'assets/media/ufg.jpg';

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: Theme.of(context).colorScheme.background,
      logo: Image.asset(_logo),
      logoWidth: 140.0,
      showLoader: true,
      loadingText: const Text('Carregando...'),
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}

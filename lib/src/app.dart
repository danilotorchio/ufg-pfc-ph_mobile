import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'shared/shared.dart'
    show
        locator,
        setupPermissions,
        AuthBloc,
        AuthState,
        AuthStatus,
        StationRepository;

import 'pages/pages.dart' show SplashPage, LoginPage, HomePage;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StationRepository(),
      child: BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'pH Station',
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      builder: (_, child) => BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) => _handleAuthStatus(state, _navigator),
        child: child,
      ),
      initialRoute: SplashPage.route,
      onGenerateRoute: locator.get<FluroRouter>().generator,
    );
  }

  _handleAuthStatus(AuthState state, NavigatorState navigator) {
    switch (state.status) {
      case AuthStatus.unknown:
        break;
      case AuthStatus.unauthenticated:
        navigator.pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
        break;
      case AuthStatus.authenticated:
        Future.delayed(Duration.zero, () async {
          setupPermissions();
          context.read<StationRepository>().turnBluetoothOn();
        });

        navigator.pushNamedAndRemoveUntil(HomePage.route, (route) => false);
        break;
    }
  }
}

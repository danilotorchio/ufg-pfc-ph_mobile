import 'dart:async';
import 'dart:developer';

import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ph_mobile/src/routes.dart';

import 'firebase_options.dart';

import 'src/app.dart';
import 'src/shared/shared.dart' show locator, SimpleBlocObserver, setupLocator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  setupLocator();

  Bloc.observer = SimpleBlocObserver();
  AppRoutes.configure(locator.get<FluroRouter>());

  runZonedGuarded(
    () => runApp(const App()),
    (error, stack) => log(error.toString(), stackTrace: stack),
  );
}

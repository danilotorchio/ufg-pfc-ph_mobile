import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

import 'src/app.dart';
import 'src/shared/shared.dart' show SimpleBlocObserver;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = SimpleBlocObserver();

  runZonedGuarded(
    () => const App(),
    (error, stack) => log(error.toString(), stackTrace: stack),
  );
}

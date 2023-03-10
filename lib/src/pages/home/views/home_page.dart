import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ph_mobile/src/shared/shared.dart'
    show StationRepository, StationCubit;

import 'home_view.dart';

class HomePage extends StatelessWidget {
  static String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<StationRepository>();

    return BlocProvider(
      create: (context) => StationCubit(repository),
      child: const HomeView(),
    );
  }
}

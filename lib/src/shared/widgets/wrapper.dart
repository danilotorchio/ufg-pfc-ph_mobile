import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ph_mobile/src/shared/shared.dart';

class PageWrapper extends StatelessWidget {
  final WidgetBuilder builder;

  const PageWrapper({super.key, required this.builder});

  void _exit(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pH Station'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _exit(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: builder(context),
        ),
      ),
    );
  }
}

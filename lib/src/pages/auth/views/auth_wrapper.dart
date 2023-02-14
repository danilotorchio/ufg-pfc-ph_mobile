import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/shared.dart';

class AuthWrapper extends StatelessWidget {
  final WidgetBuilder bodyBuilder;
  final WidgetBuilder footerBuilder;

  const AuthWrapper({
    super.key,
    required this.bodyBuilder,
    required this.footerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous.message != current.message &&
            current.message.isNotEmpty;
      },
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message))),
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 120.0,
                        width: double.infinity,
                        child: const UniversityLogo(scale: 1.4),
                      ),
                      const SizedBox(height: 36.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'pH Station',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 36.0),
                  Expanded(
                    flex: 1,
                    child: bodyBuilder(context),
                  ),
                  const SizedBox(height: 16.0),
                  footerBuilder(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

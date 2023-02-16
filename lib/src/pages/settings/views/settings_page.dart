import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:ph_mobile/src/shared/shared.dart'
    show StationRepository, StationCubit;

import 'settings_view.dart';

class SettingsPage extends StatelessWidget {
  static String route = '/settings';
  final BluetoothDevice device;

  const SettingsPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<StationRepository>();

    return BlocProvider(
      create: (context) => StationCubit(repository),
      child: SettingsView(device: device),
    );
  }
}

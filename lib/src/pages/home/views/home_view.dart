import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:ph_mobile/src/shared/shared.dart';
import '../widgets/station_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      builder: (context) => Column(
        children: [
          StreamBuilder<List<ScanResult>>(
            stream: context.read<StationCubit>().scanResults,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return _buildSearching();
              } else if ((snap.data ?? []).isNotEmpty) {
                return _buildList(context, snap.data!);
              }

              return _buildEmpty();
            },
          ),
          BlocBuilder<StationCubit, bool>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                label: 'Buscar dispositivos',
                loading: state,
                onPressed: () => context.read<StationCubit>().scanDevices(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearching() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Expanded(
      child: Center(
        child: Text('Nenhum dispositivo encontrado'),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ScanResult> items) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 4.0),
            Text(
              'Dispositivos encontrados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            Divider(color: Theme.of(context).primaryColorDark),
            Column(
              children: List.generate(
                items.length,
                (index) => Column(
                  children: [
                    StationItem(item: items[index]),
                    Divider(color: Theme.of(context).primaryColorDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

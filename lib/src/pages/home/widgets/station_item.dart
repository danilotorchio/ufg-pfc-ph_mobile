import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluro/fluro.dart';

import 'package:ph_mobile/src/pages/pages.dart' show SettingsPage;
import 'package:ph_mobile/src/shared/shared.dart';

enum _MenuItem { itemUnknown, itemConnect, itemDisconnect, itemConfigure }

extension _MenuItemExtension on _MenuItem {
  String get displayText {
    switch (this) {
      case _MenuItem.itemUnknown:
        return '';
      case _MenuItem.itemConnect:
        return 'Conectar';
      case _MenuItem.itemDisconnect:
        return 'Desconectar';
      case _MenuItem.itemConfigure:
        return 'Configurar';
    }
  }
}

class StationItem extends StatelessWidget {
  final ScanResult item;

  const StationItem({super.key, required this.item});

  bool _isConnected(BluetoothDeviceState? state) {
    return state != null && state == BluetoothDeviceState.connected;
  }

  void _onItemSelected(BuildContext context, _MenuItem menuItem) {
    switch (menuItem) {
      case _MenuItem.itemUnknown:
        break;
      case _MenuItem.itemConnect:
        item.device.connect();
        break;
      case _MenuItem.itemDisconnect:
        item.device.disconnect();
        break;
      case _MenuItem.itemConfigure:
        final router = locator.get<FluroRouter>();
        router.navigateTo(
          context,
          SettingsPage.route,
          routeSettings: RouteSettings(arguments: item.device),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: item.device.state,
      builder: (context, snap) => ListTile(
        visualDensity: VisualDensity.comfortable,
        title: _buildTitle(context, snap.data),
        leading: _buildLeading(context),
        trailing: _buildTrailing(context, snap.data),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, BluetoothDeviceState? state) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.device.name,
                    style: _isConnected(state)
                        ? Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.green)
                        : Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 14.0),
                  Row(
                    children: [
                      Text(
                        'Tx power:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${item.advertisementData.txPowerLevel} dBm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Signal:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${item.rssi} dBm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.0),
        Row(
          children: [
            Text(
              'ID:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 4.0),
            Flexible(
              child: Text(
                item.device.id.id.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Card(
      shape: CircleBorder(
        side: BorderSide(
          width: 1,
          color: Theme.of(context).primaryColorDark.withOpacity(0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.bluetooth,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, BluetoothDeviceState? state) {
    return PopupMenuButton<_MenuItem>(
      initialValue: _MenuItem.itemUnknown,
      onSelected: (menuItem) => _onItemSelected(context, menuItem),
      itemBuilder: (context) => <PopupMenuEntry<_MenuItem>>[
        PopupMenuItem(
          value: _isConnected(state)
              ? _MenuItem.itemDisconnect
              : _MenuItem.itemConnect,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bluetooth_connected),
              const SizedBox(width: 12.0),
              Text(
                _isConnected(state)
                    ? _MenuItem.itemDisconnect.displayText
                    : _MenuItem.itemConnect.displayText,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MenuItem.itemConfigure,
          enabled: _isConnected(state),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.settings_outlined),
              SizedBox(width: 12.0),
              Text('Configurar'),
            ],
          ),
        ),
      ],
    );
  }
}

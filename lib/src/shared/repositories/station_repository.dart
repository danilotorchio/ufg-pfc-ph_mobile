import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ph_mobile/src/shared/shared.dart' show SettingsDto;
import 'package:shared_preferences/shared_preferences.dart';

const _serviceUUID = '65426fae-f917-4c56-9026-2720358d212a';
const _characteristicUUID = '0951f60d-8f74-4612-9b85-d38cb6b36395';
const _prefsKey = 'ph-station-settings';

class StationRepository {
  FlutterBluePlus get _fb => FlutterBluePlus.instance;
  Stream<List<ScanResult>> get scanResults => _fb.scanResults;

  Future<void> turnBluetoothOn() async {
    bool ret;

    if (Platform.isAndroid) {
      ret = await _fb.turnOn();
    } else {
      ret = await _fb.isAvailable;
    }

    log('Bluetooth is available: $ret');
  }

  Future<List<BluetoothDevice>> getConnectedDevices() async {
    List<BluetoothDevice> items = List.empty(growable: true);
    final devices = await _fb.connectedDevices;

    for (var device in devices) {
      try {
        await device.connect();
        final services = await device.discoverServices();

        if (services.any((service) =>
            service.uuid == Guid('65426FAE-F917-4C56-9026-2720358D212A'))) {
          items.add(device);
        }

        await device.disconnect();
      } on Exception catch (e) {
        log('Error: $e');
        await device.disconnect();
      }
    }

    return items;
  }

  Future<void> scanDevices() async {
    final btPermission = await Permission.bluetooth.status;
    final btIsOn = await _fb.isOn;

    if (btPermission.isGranted && btIsOn) {
      await _fb.startScan(timeout: const Duration(seconds: 5), withServices: [
        Guid(_serviceUUID),
      ]);
    }
  }

  Future<void> applySettings(
    SettingsDto settings,
    BluetoothDevice device,
  ) async {
    final services = await device.discoverServices();

    final json = jsonEncode(settings.toJson());
    final cmd = '01:$json';

    for (var service in services) {
      if (service.uuid == Guid(_serviceUUID)) {
        for (var ch in service.characteristics) {
          if (ch.uuid == Guid(_characteristicUUID)) {
            await ch.write(cmd.codeUnits);
          }
        }
      }
    }

    await _saveSettings(json);
  }

  Future<void> _saveSettings(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, data);
  }

  Future<String?> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKey);
  }
}

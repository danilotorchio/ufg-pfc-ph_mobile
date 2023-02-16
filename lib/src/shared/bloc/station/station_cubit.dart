import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:ph_mobile/src/shared/shared.dart'
    show StationRepository, SettingsDto;

class StationCubit extends Cubit<bool> {
  final StationRepository _repository;
  Stream<List<ScanResult>> get scanResults => _repository.scanResults;

  StationCubit(StationRepository repository)
      : _repository = repository,
        super(false);

  Future<List<BluetoothDevice>> getConnectedDevices() async {
    emit(true);
    final data = await _repository.getConnectedDevices();

    emit(false);
    return data;
  }

  Future<void> scanDevices() async {
    emit(true);
    await _repository.scanDevices();
    emit(false);
  }

  Future<SettingsDto?> getSettings() async {
    final prefs = await _repository.loadSettings();

    if (prefs != null && prefs.isNotEmpty) {
      return SettingsDto.fromJson(jsonDecode(prefs));
    }

    return null;
  }

  Future<void> applySettings(
    SettingsDto settings,
    BluetoothDevice device,
  ) async {
    emit(true);
    await _repository.applySettings(settings, device);
    emit(false);
  }
}

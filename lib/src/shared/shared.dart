import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

export 'bloc/bloc.dart';
export 'repositories/repositories.dart';
export 'utils/utils.dart';
export 'widgets/widgets.dart';
export 'models/models.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<FluroRouter>(FluroRouter());
}

Future<Map<Permission, PermissionStatus>> setupPermissions() async {
  return [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ].request();
}

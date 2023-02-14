import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';

export 'bloc/bloc.dart';
export 'repositories/repositories.dart';
export 'utils/utils.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<FluroRouter>(FluroRouter());
}

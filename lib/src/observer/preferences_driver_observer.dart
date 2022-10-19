// ignore_for_file: avoid_positional_boolean_parameters

import 'package:meta/meta.dart';

abstract class PreferencesDriverObserver {
  const PreferencesDriverObserver();

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void onGet<T>(String path, T? value) {}

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void onSet<T>(String path, T value, bool isSuccess) {}

  @protected
  @mustCallSuper
  void onRemove(String path, bool isSuccess) {}

  @protected
  @mustCallSuper
  void onReload() {}

  @protected
  @mustCallSuper
  void onClear(bool isSuccess) {}
}

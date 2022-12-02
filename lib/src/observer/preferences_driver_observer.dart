// ignore_for_file: avoid_positional_boolean_parameters

import 'package:meta/meta.dart';
import 'package:typed_preferences/src/dao/preferences_driver.dart';

/// A base class for all [PreferencesDriver] observers.
///
/// Allows to override certain methods that get called on appropriate occasions.
///
/// Can be used for logging, errors reporting, reactivity and any other case
/// that "watches" entries.
abstract class PreferencesDriverObserver {
  const PreferencesDriverObserver();

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void beforeGet<T>(String path) {}

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void onGet<T>(String path, T? value) {}

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void beforeSet<T>(String path, T value) {}

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void onSet<T>(String path, T value, bool isSuccess) {}

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void beforeRemove<T>(String path) {}

  @protected
  @optionalTypeArgs
  @mustCallSuper
  void onRemove<T>(String path, bool isSuccess) {}

  @protected
  @mustCallSuper
  void beforeReload() {}

  @protected
  @mustCallSuper
  void onReload() {}

  @protected
  @mustCallSuper
  void beforeClear() {}

  @protected
  @mustCallSuper
  void onClear(bool isSuccess) {}
}

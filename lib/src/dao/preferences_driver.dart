// ignore_for_file: invalid_use_of_protected_member

import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/src/dao/preferences_entry.dart';
import 'package:typed_preferences/src/observer/preferences_driver_observer.dart';

/// Provides access to operations that affect all [SharedPreferences] values.
abstract class GlobalPreferencesDriverOperator {
  Set<String> get keys;

  Future<bool> clear();

  Future<void> reload();
}

/// Provides access to CRUD-related operation that affect a given
/// [PreferencesEntry]
abstract class EntryPreferencesDriverOperator {
  bool exists<T extends Object>(PreferencesEntry<T> entry);

  Future<bool> remove<T extends Object>(PreferencesEntry<T> entry);

  Future<bool> setValue<T extends Object>(PreferencesEntry<T> entry, T value);

  T? getValue<T extends Object>(PreferencesEntry<T> entry);
}

/// Combines [GlobalPreferencesDriverOperator]
/// and [EntryPreferencesDriverOperator], while providing a default
/// implementation for the interfaces.
///
/// Accepts an optional list of observers that implement
/// [PreferencesDriverObserver] and invokes appropriate hook methods on
abstract class PreferencesDriver
    implements GlobalPreferencesDriverOperator, EntryPreferencesDriverOperator {
  factory PreferencesDriver({
    required SharedPreferences sharedPreferences,
    List<PreferencesDriverObserver> observers,
  }) = _PreferencesDriver;
}

/// Thrown when [EntryPreferencesDriverOperator] is unable to process a
/// given [PreferencesEntry] implementation due to type-parameter [T].
class UnknownPreferencesEntryException<T extends Object> implements Exception {
  const UnknownPreferencesEntryException();
}

class _PreferencesDriver implements PreferencesDriver {
  final SharedPreferences sharedPreferences;
  final List<PreferencesDriverObserver> observers;

  _PreferencesDriver({
    required this.sharedPreferences,
    this.observers = const [],
  });

  void _forObservers(
    void Function(PreferencesDriverObserver observer) callback,
  ) {
    observers.forEach(callback);
  }

  R _matchEntry<T extends Object, R>(
    PreferencesEntry<T> entry, {
    required R Function() onString,
    required R Function() onBool,
    required R Function() onInt,
    required R Function() onDouble,
    required R Function() onsStringList,
  }) {
    if (entry is PreferencesEntry<String>) return onString();
    if (entry is PreferencesEntry<bool>) return onBool();
    if (entry is PreferencesEntry<int>) return onInt();
    if (entry is PreferencesEntry<double>) return onDouble();
    if (entry is PreferencesEntry<List<String>>) return onsStringList();
    throw UnknownPreferencesEntryException<T>();
  }

  @override
  Set<String> get keys => sharedPreferences.getKeys();

  @override
  Future<bool> clear() async {
    final isSuccess = await sharedPreferences.clear();

    _forObservers((observer) => observer.onClear(isSuccess));

    return isSuccess;
  }

  @override
  Future<void> reload() async {
    await sharedPreferences.reload();

    _forObservers((observer) => observer.onReload());
  }

  @override
  bool exists<T extends Object>(PreferencesEntry<T> entry) =>
      sharedPreferences.containsKey(entry.key);

  @override
  Future<bool> remove<T extends Object>(PreferencesEntry<T> entry) async {
    final path = entry.key;
    final isSuccess = await sharedPreferences.remove(path);

    _forObservers(
      (observer) => observer.onRemove(path, isSuccess),
    );

    return isSuccess;
  }

  @override
  Future<bool> setValue<T extends Object>(
    PreferencesEntry<T> entry,
    T value,
  ) async {
    final key = entry.key;
    final isSuccess = await _matchEntry<T, Future<bool>>(
      entry,
      onString: () => sharedPreferences.setString(key, value as String),
      onBool: () => sharedPreferences.setBool(key, value as bool),
      onInt: () => sharedPreferences.setInt(key, value as int),
      onDouble: () => sharedPreferences.setDouble(key, value as double),
      onsStringList: () => sharedPreferences.setStringList(
        key,
        value as List<String>,
      ),
    );

    _forObservers(
      (observer) => observer.onSet(key, value, isSuccess),
    );

    return isSuccess;
  }

  @override
  T? getValue<T extends Object>(PreferencesEntry<T> entry) {
    final key = entry.key;
    final value = _matchEntry<T, Object?>(
      entry,
      onString: () => sharedPreferences.getString(key),
      onBool: () => sharedPreferences.getBool(key),
      onInt: () => sharedPreferences.getInt(key),
      onDouble: () => sharedPreferences.getDouble(key),
      onsStringList: () => sharedPreferences.getStringList(key),
    );

    _forObservers(
      (observer) => observer.onGet(key, value),
    );

    return value as T?;
  }
}

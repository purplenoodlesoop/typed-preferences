import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/src/dao/preferences_driver.dart';
import 'package:typed_preferences/src/dao/preferences_entry.dart';
import 'package:typed_preferences/src/util/memento.dart';

/// A base class for DAOs that allows to define a schema-like object that
/// works with [SharedPreferences].
///
/// Entry creators are memoized internally and should be declared as getters.
///
/// An example DAO can look like the following:
/// ```dart
/// class SettingsDao extends TypedPreferencesDao {
///   SettingsDao(PreferencesDriver driver) : super(driver: driver);
///
///   @override
///   String get name => 'settings';
///
///   PreferencesEntry<String> get userName => stringEntry('name');
///
///   PreferencesEntry<int> get userAge => intEntry('age');
/// }
/// ```
abstract class TypedPreferencesDao {
  final PreferencesDriver _driver;

  TypedPreferencesDao(PreferencesDriver driver) : _driver = driver;

  late final Memento _memento = Memento();

  late final String _defaultName =
      runtimeType.toString().replaceFirst('Dao', '').toLowerCase();

  String get name => _defaultName;

  String _assembleKey(String key) => 'typed.$name.$key';

  PreferencesEntry<T> _entry<T extends Object>(String key) {
    final fullKey = _assembleKey(key);

    return _memento.create(
      fullKey,
      () => _PreferencesEntry(fullKey, _driver),
    );
  }

  /// Creates a [PreferencesEntry] of type [String] and caches internally.
  @nonVirtual
  @protected
  PreferencesEntry<String> stringEntry(String key) => _entry(key);

  /// Creates a [PreferencesEntry] of type [int] and caches internally.
  @nonVirtual
  @protected
  PreferencesEntry<int> intEntry(String key) => _entry(key);

  /// Creates a [PreferencesEntry] of type [double] and caches internally.
  @nonVirtual
  @protected
  PreferencesEntry<double> doubleEntry(String key) => _entry(key);

  /// Creates a [PreferencesEntry] of type [bool] and caches internally.
  @nonVirtual
  @protected
  PreferencesEntry<bool> boolEntry(String key) => _entry(key);

  /// Creates a [PreferencesEntry] of type [List<String>] and caches internally.
  @nonVirtual
  @protected
  PreferencesEntry<List<String>> stringListEntry(String key) => _entry(key);
}

class _PreferencesEntry<T extends Object> implements PreferencesEntry<T> {
  final PreferencesDriver _driver;
  @override
  final String key;

  const _PreferencesEntry(this.key, this._driver);

  @override
  bool get exists => _driver.exists(this);

  @override
  Future<bool> remove() => _driver.remove(this);

  @override
  Future<bool> setValue(T value) => _driver.setValue(this, value);

  @override
  T? get value => _driver.getValue(this);
}

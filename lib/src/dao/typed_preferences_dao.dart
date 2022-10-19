import 'package:meta/meta.dart';
import 'package:typed_preferences/src/dao/preferences_driver.dart';
import 'package:typed_preferences/src/dao/preferences_entry.dart';
import 'package:typed_preferences/src/util/memento.dart';

abstract class TypedPreferencesDao {
  final PreferencesDriver _driver;

  TypedPreferencesDao({
    required PreferencesDriver driver,
  }) : _driver = driver;

  late final Memento _memento = Memento();

  String get name;

  String _assembleKey(String key) => 'typed.$name.$key';

  PreferencesEntry<T> _entry<T extends Object>(String key) {
    final fullKey = _assembleKey(key);

    return _memento.create(
      fullKey,
      () => _PreferencesEntry(fullKey, _driver),
    );
  }

  @nonVirtual
  @protected
  PreferencesEntry<String> stringEntry(String key) => _entry(key);

  @nonVirtual
  @protected
  PreferencesEntry<int> intEntry(String key) => _entry(key);

  @nonVirtual
  @protected
  PreferencesEntry<double> doubleEntry(String key) => _entry(key);

  @nonVirtual
  @protected
  PreferencesEntry<bool> boolEntry(String key) => _entry(key);

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

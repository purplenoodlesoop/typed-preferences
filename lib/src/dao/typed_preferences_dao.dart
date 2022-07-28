import 'package:typed_preferences/src/dao/preferences_driver.dart';
import 'package:typed_preferences/src/dao/preferences_entry.dart';

abstract class TypedPreferencesDao {
  final String _name;
  final PreferencesDriver _driver;

  TypedPreferencesDao({
    required String name,
    required PreferencesDriver driver,
  })  : _name = name,
        _driver = driver;

  PreferencesEntry<String> stringEntry(String key) =>
      throw UnimplementedError();
}

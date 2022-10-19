import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:typed_preferences/typed_preferences.dart';

class _DriverTestDao extends TypedPreferencesDao {
  _DriverTestDao({required PreferencesDriver driver}) : super(driver: driver);

  @override
  String get name => 'driver_test';

  PreferencesEntry<String> get first => stringEntry('first');

  PreferencesEntry<String> get second => stringEntry('second');
}

void main() {
  late PreferencesDriver driver;
  late List<PreferencesEntry<String>> entries;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    driver = PreferencesDriver(sharedPreferences: preferences);
    final dao = _DriverTestDao(driver: driver);
    entries = [dao.first, dao.second];
  });
  Future<void> populate() => Future.wait(
        entries.map((entry) => entry.setValue('value')),
      );
  void expectKeys(Matcher matcher) {
    expect(driver.keys, matcher);
  }

  void expectKeysAreEmpty() {
    expectKeys(isEmpty);
  }

  group('PreferencesDriver >', () {
    test('Settings keys is reflected in .keys getter', () async {
      expectKeysAreEmpty();
      await populate();
      expectKeys(equals(entries.map((entry) => entry.key).toSet()));
    });
    test('.clear() resets keys to an empty state', () async {
      await populate();
      await driver.clear();
      expectKeysAreEmpty();
    });
  });
}

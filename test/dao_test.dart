import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:typed_preferences/typed_preferences.dart';

class _DaoTestDao extends TypedPreferencesDao {
  _DaoTestDao({required PreferencesDriver driver}) : super(driver);

  PreferencesEntry<String> get exampleString => stringEntry('String');

  PreferencesEntry<int> get exampleInt => intEntry('int');

  PreferencesEntry<double> get exampleDouble => doubleEntry('double');

  PreferencesEntry<bool> get exampleBool => boolEntry('bool');

  PreferencesEntry<List<String>> get exampleStringList =>
      stringListEntry('List<String>');
}

void _testEntry<T extends Object>(
  T exampleValue,
  PreferencesEntry<T> Function(_DaoTestDao dao) selectEntry,
) {
  late PreferencesEntry<T> entry;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    entry = selectEntry(
      _DaoTestDao(
        driver: PreferencesDriver(
          sharedPreferences: preferences,
        ),
      ),
    );
  });
  T? value() => entry.value;
  Future<void> populate() => entry.setValue(exampleValue);
  void expectDoesNotExists() {
    expect(entry.exists, isFalse);
    expect(value(), isNull);
  }

  group('PreferencesEntry<$T> >', () {
    test('Key gets prefixed with typed and DAO name', () {
      expect(entry.key, equals('typed._testdao.$T'));
    });
    test('Value does not exists before setting it', expectDoesNotExists);
    test('Setting value changes .value and .exists getters output', () async {
      await populate();
      expect(entry.exists, isTrue);
      expect(value(), equals(exampleValue));
    });
    test('Removing value after populating it resets value-getters', () async {
      await populate();
      await entry.remove();
      expectDoesNotExists();
    });
  });
}

void main() {
  group('TypedPreferencesDao >', () {
    _testEntry<String>('string', (dao) => dao.exampleString);
    _testEntry<int>(1, (dao) => dao.exampleInt);
    _testEntry<double>(2, (dao) => dao.exampleDouble);
    _testEntry<bool>(true, (dao) => dao.exampleBool);
    _testEntry<List<String>>(const ['entry'], (dao) => dao.exampleStringList);
  });
}

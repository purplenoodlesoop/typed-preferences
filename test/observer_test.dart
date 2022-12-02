import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:typed_preferences/typed_preferences.dart';

class _ActionWriterObserver implements PreferencesDriverObserver {
  final List<String> _actions;

  _ActionWriterObserver(this._actions);

  void _writeAction(List<Object?> parts) {
    _actions.add(parts.toString());
  }

  @override
  void onGet<T extends Object>(String path, T? value) {
    _writeAction(['onGet', path, value]);
  }

  @override
  void onSet<T extends Object>(String path, T value, bool isSuccess) {
    _writeAction(['onSet', path, value, isSuccess]);
  }

  @override
  void onRemove<T extends Object>(String path, bool isSuccess) {
    _writeAction(['onRemove', path, isSuccess]);
  }

  @override
  void onReload() {
    _writeAction(['onReload']);
  }

  @override
  void onClear(bool isSuccess) {
    _writeAction(['onClear', isSuccess]);
  }

  @override
  void beforeClear() {
    _writeAction(['beforeClear']);
  }

  @override
  void beforeGet<T extends Object>(String path) {
    _writeAction(['beforeGet', path, T]);
  }

  @override
  void beforeReload() {
    _writeAction(['beforeReload']);
  }

  @override
  void beforeRemove<T extends Object>(String path) {
    _writeAction(['beforeRemove', path, T]);
  }

  @override
  void beforeSet<T extends Object>(String path, T value) {
    _writeAction(['beforeSet', path, T]);
  }
}

class _ObserverTestDao extends TypedPreferencesDao {
  _ObserverTestDao({required PreferencesDriver driver}) : super(driver);

  PreferencesEntry<String> get entry => stringEntry('key');
}

void main() {
  const value = 'value';
  final actions = <String>[];
  late PreferencesDriver driver;
  late PreferencesEntry<String> entry;

  void expectContainsAction(List<Object?> action) {
    expect(actions, contains(action.toString()));
  }

  Future<bool> populate() => entry.setValue(value);

  String key() => entry.key;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    driver = PreferencesDriver(
      sharedPreferences: preferences,
      observers: [
        _ActionWriterObserver(actions),
      ],
    );
    entry = _ObserverTestDao(driver: driver).entry;
  });
  group('PreferencesDriverObserver >', () {
    test('set', () async {
      final isSuccess = await populate();
      final path = key();
      expectContainsAction(['beforeSet', path, String]);
      expectContainsAction(['onSet', path, value, isSuccess]);
    });
    test('get', () async {
      await populate();
      final value = entry.value;
      final path = key();
      expectContainsAction(['beforeGet', path, String]);
      expectContainsAction(['onGet', path, value]);
    });
    test('remove', () async {
      await populate();
      final isSuccess = await entry.remove();
      final path = key();
      expectContainsAction(['beforeRemove', path, String]);
      expectContainsAction(['onRemove', path, isSuccess]);
    });
    test('reload', () async {
      await driver.reload();
      expectContainsAction(['beforeReload']);
      expectContainsAction(['onReload']);
    });
    test('clear', () async {
      final isSuccess = await driver.clear();
      expectContainsAction(['beforeClear']);
      expectContainsAction(['onClear', isSuccess]);
    });
  });
}

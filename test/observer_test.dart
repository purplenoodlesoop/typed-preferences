import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:typed_preferences/typed_preferences.dart';

class _ActionWriterObserver extends PreferencesDriverObserver {
  final List<String> _actions;

  _ActionWriterObserver(this._actions);

  void _writeAction(List<Object?> parts) {
    _actions.add(parts.toString());
  }

  @override
  void onGet<T>(String path, T? value) {
    super.onGet<T>(path, value);
    _writeAction(['onGet', path, value]);
  }

  @override
  void onSet<T>(String path, T value, bool isSuccess) {
    super.onSet<T>(path, value, isSuccess);
    _writeAction(['onSet', path, value, isSuccess]);
  }

  @override
  void onRemove(String path, bool isSuccess) {
    super.onRemove(path, isSuccess);
    _writeAction(['onRemove', path, isSuccess]);
  }

  @override
  void onReload() {
    super.onReload();
    _writeAction(['onReload']);
  }

  @override
  void onClear(bool isSuccess) {
    super.onClear(isSuccess);
    _writeAction(['onClear', isSuccess]);
  }
}

class _ObserverTestDao extends TypedPreferencesDao {
  _ObserverTestDao({required PreferencesDriver driver}) : super(driver: driver);

  @override
  String get name => 'observer_test';

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
    test('onSet', () async {
      final isSuccess = await populate();
      expectContainsAction(['onSet', key(), value, isSuccess]);
    });
    test('onGet', () async {
      await populate();
      final value = entry.value;
      expectContainsAction(['onGet', key(), value]);
    });
    test('onRemove', () async {
      await populate();
      final isSuccess = await entry.remove();
      expectContainsAction(['onRemove', key(), isSuccess]);
    });
    test('onReload', () async {
      await driver.reload();
      expectContainsAction(['onReload']);
    });
    test('onClear', () async {
      final isSuccess = await driver.clear();
      expectContainsAction(['onClear', isSuccess]);
    });
  });
}

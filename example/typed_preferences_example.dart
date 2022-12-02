// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

class LoggerPreferencesDriverObserver extends PreferencesDriverObserver {
  const LoggerPreferencesDriverObserver();

  void _log(void Function(StringBuffer b) logBuilder) {
    final buffer = StringBuffer('LoggerPreferencesDriverObserver | ');
    logBuilder(buffer);
    print(buffer.toString());
  }

  @override
  void beforeSet<T>(String path, T value) {
    super.beforeSet(path, value);
    _log(
      (b) => b
        ..write('Setting ')
        ..write(path)
        ..write(' of type ')
        ..write(T)
        ..write(' to ')
        ..write(value),
    );
  }

  @override
  void onSet<T>(String path, T value, bool isSuccess) {
    super.onSet(path, value, isSuccess);
    _log(
      (b) => b
        ..write('Set ')
        ..write(path)
        ..write(' to value ')
        ..write(value)
        ..write(' ')
        ..write(isSuccess ? 'successfully' : 'unsuccessfully'),
    );
  }
}

class SettingsDao extends TypedPreferencesDao {
  SettingsDao(PreferencesDriver driver) : super(driver);

  @override
  String get name => 'settings';

  PreferencesEntry<String> get userName => stringEntry('name');

  PreferencesEntry<int> get userAge => intEntry('age');
}

Future<void> main() async {
  final preferences = await SharedPreferences.getInstance();

  final driver = PreferencesDriver(
    sharedPreferences: preferences,
    observers: const [LoggerPreferencesDriverObserver()],
  );

  final settingsDao = SettingsDao(driver);

  await settingsDao.userName.setValue('Joe');
  await settingsDao.userAge.setValue(20);
  print(settingsDao.userName.value);
  print(settingsDao.userAge.value);
  await settingsDao.userName.setValue('Jeff');
  await settingsDao.userAge.setValue(30);
  print(settingsDao.userName.value);
  print(settingsDao.userAge.value);
}

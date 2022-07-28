// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/src/dao/preferences_driver.dart';
import 'package:typed_preferences/src/observer/preferences_driver_observer.dart';
import 'package:typed_preferences/src/dao/preferences_entry.dart';
import 'package:typed_preferences/src/dao/typed_preferences_dao.dart';

class LoggerPreferencesDriverObserver extends PreferencesDriverObserver {
  const LoggerPreferencesDriverObserver();

  void _log(void Function(StringBuffer b) logBuilder) {
    final buffer = StringBuffer('LoggerPreferencesDriverObserver | ');
    logBuilder(buffer);
    print(buffer.toString());
  }

  @override
  void onSet<T>(String path, T value, bool isSuccess) {
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
  SettingsDao(PreferencesDriver driver)
      : super(name: 'settings', driver: driver);

  PreferencesEntry<String> get name => stringEntry('name');
}

Future<void> main() async {
  final preferences = await SharedPreferences.getInstance();

  final driver = PreferencesDriver(
    sharedPreferences: preferences,
    observers: const [LoggerPreferencesDriverObserver()],
  );

  final settingsDao = SettingsDao(driver);

  print(settingsDao.name.value);
  await settingsDao.name.setValue('Joe');
  print(settingsDao.name.value);
}

//

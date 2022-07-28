import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/src/observer/preferences_driver_observer.dart';

class PreferencesDriver {
  final SharedPreferences _preferences;
  final List<PreferencesDriverObserver> _observers;

  PreferencesDriver({
    required SharedPreferences sharedPreferences,
    required List<PreferencesDriverObserver> observers,
  })  : _preferences = sharedPreferences,
        _observers = observers;
}

import 'package:typed_preferences/src/observer/preferences_driver_observer.dart';

class CombiningDriverObserver implements PreferencesDriverObserver {
  final List<PreferencesDriverObserver> _observers;

  CombiningDriverObserver({
    required List<PreferencesDriverObserver> observers,
  }) : _observers = observers;

  void _forObservers(
    void Function(PreferencesDriverObserver observer) callback,
  ) {
    _observers.forEach(callback);
  }

  @override
  void beforeClear() {
    _forObservers((observer) => observer.beforeClear());
  }

  @override
  void beforeGet<T extends Object>(String path) {
    _forObservers((observer) => observer.beforeGet<T>(path));
  }

  @override
  void beforeReload() {
    _forObservers((observer) => observer.beforeReload());
  }

  @override
  void beforeRemove<T extends Object>(String path) {
    _forObservers((observer) => observer.beforeRemove<T>(path));
  }

  @override
  void beforeSet<T extends Object>(String path, T value) {
    _forObservers((observer) => observer.beforeSet<T>(path, value));
  }

  @override
  void onClear(bool isSuccess) {
    _forObservers((observer) => observer.onClear(isSuccess));
  }

  @override
  void onGet<T extends Object>(String path, T? value) {
    _forObservers((observer) => observer.onGet<T>(path, value));
  }

  @override
  void onReload() {
    _forObservers((observer) => observer.onReload());
  }

  @override
  void onRemove<T extends Object>(String path, bool isSuccess) {
    _forObservers((observer) => observer.onRemove<T>(path, isSuccess));
  }

  @override
  void onSet<T extends Object>(String path, T value, bool isSuccess) {
    _forObservers((observer) => observer.onSet(path, value, isSuccess));
  }
}

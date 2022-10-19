// ignore_for_file: avoid_positional_boolean_parameters

abstract class PreferencesDriverObserver {
  const PreferencesDriverObserver();

  void onGet<T>(String path, T? value) {}

  void onSet<T>(String path, T value, bool isSuccess) {}

  void onRemove(String path, bool isSuccess) {}

  void onReload() {}

  void onClear(bool isSuccess) {}
}

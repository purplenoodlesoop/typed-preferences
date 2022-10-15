abstract class PreferencesEntry<T extends Object> {
  String get key;

  T? get value;

  bool get exists;

  Future<bool> setValue(T value);

  Future<bool> remove();
}

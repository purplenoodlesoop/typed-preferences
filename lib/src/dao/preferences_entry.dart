/// Describes a single SharedPreferences entry with associated type [T]
/// and [key] with it.
///
/// Allows to perform CRUD-related operations and provides meta-information
/// about the entry, such as type [T], [key], and [exists].
abstract class PreferencesEntry<T extends Object> {
  String get key;

  T? get value;

  bool get exists;

  Future<bool> setValue(T value);

  Future<bool> remove();
}

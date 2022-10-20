# typed_preferences 

typed_preferences provides a type-safe wrapper around Shared Preferences with additional features like Observers and DAOs.

## Index

- [Index](#index)
- [Motivation](#motivation)
- [Usage](#usage)
    - [Driver](#driver)
    - [DAOs](#daos)
    - [Observers](#observers)

## Motivation

Shared Preferences are usable as-is and provide an excellent multi-platform experience, but fall short in Safety and Developer Experience. Typed Preferences try to solve those problems by creating a wrapper that exposes concise, expressive, and type-safe API.

Turning this:

```dart
extension UserKey on Never {
  static const String name = 'user.name';
  static const String age = 'user.age';
}
```

```dart
class UserDao {
  final SharedPreferences _preferences;

  UserDao(this._preferences);

  String get name => _preferences.getString(UserKeys.name);

  String get age => _preferences.getInt(UserKeys.age);

  // Note – you can try to set String and get int, resulting in a runtime type error
  Future<void> setName(String name) => _preferences.setString(UserKeys.name, name);

  Future<void> setAge(int age) => _preferences.setInt(UserKeys.age, age);
}
```

Into this:

```dart
class UserDao extends TypedPreferencesDao {
  UserDao(super.driver);

  // Everything type-safe! Also, the resulting key will be `typed.user.name`
  PreferencesEntry<String> get name => stringEntry('name');

  PreferencesEntry<int> get age => intEntry('age');
}
```

## Usage

The package offers four main actors that are used throughout every interaction: `PreferencesDriver`, `PreferencesDriverObserver`, `TypedPreferencesDao`, and `PreferencesEntry<T>`. Every one of them will be discussed below, but the usage is quite simple – DAOs need Drivers to function, and entries are declared as getters from the DAOs.

### Driver

`PreferencesDriver` is needed by DAOs to operate. It is usually a shared object that is passed to every DAO in the constructor. Besides providing actual "driver" functionality, the `PreferencesDriver` is used to set up Observers, which will be discussed later. 

Since usually there is only one driver needed, in Flutter application the best place to create one is in the `main()` function. The driver is not stateful and does not require disposal after usage.

```dart
final preferences = await SharedPreferences.getInstance();

final driver = PreferencesDriver(
  sharedPreferences: preferences,
  observers: const [LoggerPreferencesDriverObserver()],
);

runApp(App(driver: driver));
```

### DAOs

DAOs are used to describe schema-like classes with two-way type-safe entries. To create a DAO, a concrete class should extend the `TypedPreferencesDao` base class and pass a `PreferencesDriver` to a super-constructor. To declare DAOs' entries, any of the following methods are used – `stringEntry`, `intEntry`, `doubleEntry`, `boolEntry`, `stringListEntry`.

The most simple DAO can look something like that: 

```dart
class ExampleDao extends TypedPreferencesDao {
  ExampleDao(super.driver);

  PreferencesEntry<String> get someEntry => stringEntry('some_key');
}
```

A few things are happening behind the scenes:
  1. Every key passed to the methods is prefixed with `typed.` and the name of the DAO. So, in the case of `someEntry`, the resulting key would be `typed.example.some_key`. The `example` name can be overridden via the `name` getter.
  2. Entries are cached by key. So, only on the first access to the `someEntry` field the object will be created and written in the cache by the given `some_key`,
  3. Observers connected to the `PreferencesDriver` will fire on declared entries manipulations.

### Observers

Observers can be created by extending the base class `PreferencesDriverObserver` and connected via the `observers` argument of the `PreferencesDriver`'s constructor. Several methods can be overridden, and the usage can vary – from logging to reactivity.

An example of a logger-observer can look like the following: 

```dart
class LoggerPreferencesDriverObserver extends PreferencesDriverObserver {
  const LoggerPreferencesDriverObserver();

  void _log(void Function(StringBuffer b) logBuilder) {
    final buffer = StringBuffer('LoggerPreferencesDriverObserver | ');
    logBuilder(buffer);
    print(buffer.toString());
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
```
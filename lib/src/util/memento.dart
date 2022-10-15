abstract class Memento<K extends Object, V extends Object?> {
  factory Memento() => _Memento();

  T create<T extends V>(K key, T Function() create);

  void dropCache();
}

class _Memento<K extends Object, V extends Object?> implements Memento<K, V> {
  late final Map<K, V> _cache = {};

  @override
  T create<T extends V>(K key, T Function() create) =>
      _cache.putIfAbsent(key, create) as T;

  @override
  void dropCache() {
    _cache.clear();
  }
}

import 'package:test/test.dart';
import 'package:typed_preferences/src/util/memento.dart';

void main() {
  late Memento memento;
  setUp(() {
    memento = Memento();
  });
  tearDown(() {
    memento.dropCache();
  });

  Object sameKey() => memento.create('key', () => Object());
  group('Memento >', () {
    group('Create >', () {
      test('Same key persist the value', () {
        expect(sameKey(), same(sameKey()));
      });
      test('Different keys yield different values', () {
        expect(
          memento.create('actual', () => Object()),
          isNot(memento.create('matcher', () => Object())),
        );
      });
    });
    group('Drop cache >', () {
      test('Same key yields different values after dropping the cache', () {
        final first = sameKey();
        memento.dropCache();
        final second = sameKey();
        expect(first, isNot(second));
      });
    });
  });
}

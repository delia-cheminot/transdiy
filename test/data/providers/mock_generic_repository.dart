import 'package:mockito/mockito.dart';
import 'package:transdiy/services/repository.dart';

class MockGenericRepository<T extends dynamic> extends Mock
    implements Repository<T> {
  final List<T> _items = [];
  int _nextId = 1;
  final T Function(T, int) withId;

  MockGenericRepository({required this.withId});

  List<T> get items => _items;

  @override
  Future<int> insert(T item) async {
    final id = item.id ?? _nextId++;
    final newItem = withId(item, id);
    _items.add(newItem);
    return (newItem as dynamic).id;
  }

  @override
  Future<void> update(T item, int id) async {
    final index = _items.indexWhere((i) => (i as dynamic).id == id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> delete(int id) async {
    _items.removeWhere((i) => (i as dynamic).id == id);
  }

  @override
  Future<List<T>> getAll() async {
    return List.from(_items);
  }
}
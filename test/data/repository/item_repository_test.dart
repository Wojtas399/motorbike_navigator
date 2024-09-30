import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/repository/item_repository.dart';

class TestModel extends Equatable {
  final String name;
  final int age;

  const TestModel({
    required this.name,
    required this.age,
  });

  @override
  List<Object?> get props => [name, age];
}

class TestRepository extends ItemRepository<TestModel> {}

void main() {
  late ItemRepository itemRepository;

  setUp(() {
    itemRepository = TestRepository();
  });

  test(
    'initial state should be null',
    () async {
      final repoState$ = itemRepository.repositoryState$;

      expect(await repoState$.first, null);
    },
  );

  test(
    'updateState, '
    'should update item in repo state',
    () async {
      const TestModel updatedItem = TestModel(
        name: 'name',
        age: 20,
      );

      itemRepository.updateState(updatedItem);

      expect(await itemRepository.repositoryState$.first, updatedItem);
    },
  );
}

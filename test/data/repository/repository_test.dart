import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/repository/repository.dart';
import 'package:motorbike_navigator/entity/entity.dart';

class TestModel extends Entity {
  final String name;

  const TestModel({required super.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class TestRepository extends Repository<TestModel> {}

void main() {
  late Repository repository;

  setUp(() {
    repository = TestRepository();
  });

  test(
    'initial state should be empty list',
    () async {
      final state = await repository.repositoryState$.first;

      expect(state, []);
    },
  );

  test(
    'isRepositoryStateEmpty, '
    'should return true if repository state is empty array',
    () {
      expect(repository.isRepositoryStateEmpty, true);
    },
  );

  test(
    'isRepositoryStateEmpty, '
    'should return false if repository state is not empty array',
    () {
      final List<TestModel> entities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      repository.setEntities(entities);

      expect(repository.isRepositoryStateEmpty, false);
    },
  );

  test(
    'setEntities, '
    'should assign list of entities to state',
    () {
      final List<TestModel> entities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      repository.setEntities(entities);

      expect(repository.repositoryState$, emits(entities));
    },
  );

  test(
    'addEntity, '
    'entity with the same id already exists in state, '
    'should throw exception',
    () {
      const TestModel newEntity = TestModel(id: 'e1', name: 'entity 1');
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final String expectedException =
          '[Repository] Entity $newEntity already exists in repository state';
      repository.setEntities(existingEntities);

      Object? exception;
      try {
        repository.addEntity(newEntity);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
    },
  );

  test(
    'addEntity, '
    'should add new entity to state',
    () {
      const TestModel newEntity = TestModel(id: 'e3', name: 'entity 3');
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final List<TestModel> expectedEntities = [
        ...existingEntities,
        newEntity,
      ];
      repository.setEntities(existingEntities);

      repository.addEntity(newEntity);

      expect(repository.repositoryState$, emits(expectedEntities));
    },
  );
}

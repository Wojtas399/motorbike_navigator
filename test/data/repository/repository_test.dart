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
      repository.addEntity(
        const TestModel(
          id: 1,
          name: 'name',
        ),
      );

      expect(repository.isRepositoryStateEmpty, false);
    },
  );

  test(
    'addEntity, '
    'entity with the same id already exists in state, '
    'should throw exception',
    () {
      const TestModel newEntity = TestModel(id: 1, name: 'entity 1');
      final List<TestModel> existingEntities = [
        const TestModel(id: 1, name: 'first entity'),
        const TestModel(id: 2, name: 'second entity'),
      ];
      final String expectedException =
          '[Repository] Entity $newEntity already exists in repository state';
      repository.addEntities(existingEntities);

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
      const TestModel newEntity = TestModel(id: 3, name: 'entity 3');
      final List<TestModel> existingEntities = [
        const TestModel(id: 1, name: 'first entity'),
        const TestModel(id: 2, name: 'second entity'),
      ];
      final List<TestModel> expectedEntities = [
        ...existingEntities,
        newEntity,
      ];
      repository.addEntities(existingEntities);

      repository.addEntity(newEntity);

      expect(repository.repositoryState$, emits(expectedEntities));
    },
  );

  test(
    'addEntities, '
    'list of entities to add is empty, '
    'should throw exception',
    () {
      const List<TestModel> entitiesToAdd = [];
      final String expectedException =
          '[Repository] List of entities (type $TestModel) to add is empty';

      Object? exception;
      try {
        repository.addEntities(entitiesToAdd);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
    },
  );

  test(
    'addEntities, '
    'one of the entities already exists in state, '
    'should omit duplicated entity',
    () {
      const List<TestModel> entitiesToAdd = [
        TestModel(id: 1, name: 'first entity'),
        TestModel(id: 2, name: 'second entity'),
        TestModel(id: 3, name: 'third entity'),
      ];
      const List<TestModel> existingEntities = [
        TestModel(id: 3, name: 'third entity'),
        TestModel(id: 4, name: 'fourth entity'),
        TestModel(id: 5, name: 'fifth entity'),
      ];
      final List<TestModel> expectedEntities = [
        ...existingEntities,
        entitiesToAdd.first,
        entitiesToAdd[1],
      ];
      repository.addEntities(existingEntities);

      repository.addEntities(entitiesToAdd);

      expect(repository.repositoryState$, emits(expectedEntities));
    },
  );

  test(
    'addEntities, '
    'should add all passed entities to state',
    () {
      const List<TestModel> entitiesToAdd = [
        TestModel(id: 1, name: 'first entity'),
        TestModel(id: 2, name: 'second entity'),
        TestModel(id: 3, name: 'third entity'),
      ];
      const List<TestModel> existingEntities = [
        TestModel(id: 4, name: 'fourth entity'),
        TestModel(id: 5, name: 'fifth entity'),
      ];
      final List<TestModel> expectedEntities = [
        ...existingEntities,
        ...entitiesToAdd,
      ];
      repository.addEntities(existingEntities);

      repository.addEntities(entitiesToAdd);

      expect(repository.repositoryState$, emits(expectedEntities));
    },
  );

  test(
    'updateEntity, '
    'entity does not exist in state, '
    'should do nothing',
    () {
      const TestModel updateEntity = TestModel(id: 2, name: 'entity 2');
      const List<TestModel> existingEntities = [
        TestModel(id: 1, name: 'entity 1'),
        TestModel(id: 3, name: 'entity 3'),
      ];
      repository.addEntities(existingEntities);

      repository.updateEntity(updateEntity);

      expect(repository.repositoryState$, emits(existingEntities));
    },
  );

  test(
    'updateEntity, '
    'should update entity in state',
    () {
      const TestModel updateEntity = TestModel(
        id: 2,
        name: 'updated entity 2',
      );
      const List<TestModel> existingEntities = [
        TestModel(id: 1, name: 'entity 1'),
        TestModel(id: 2, name: 'entity 2'),
        TestModel(id: 3, name: 'entity 3'),
      ];
      repository.addEntities(existingEntities);

      repository.updateEntity(updateEntity);

      expect(
        repository.repositoryState$,
        emits([existingEntities.first, updateEntity, existingEntities.last]),
      );
    },
  );
}

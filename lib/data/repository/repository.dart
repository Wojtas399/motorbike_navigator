import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/entity.dart';

abstract class Repository<T extends Entity> {
  final BehaviorSubject<List<T>> _repositoryState$ =
      BehaviorSubject<List<T>>.seeded([]);

  Stream<List<T>> get repositoryState$ => _repositoryState$.stream;

  bool get isRepositoryStateEmpty => _repositoryState$.value.isEmpty == true;

  void addEntity(T entity) {
    final bool doesEntityExist = _repositoryState$.value.firstWhereOrNull(
          (element) => element.id == entity.id,
        ) !=
        null;
    if (doesEntityExist) {
      throw '[Repository] Entity $entity already exists in repository state';
    }
    final List<T> entities = [..._repositoryState$.value];
    entities.add(entity);
    _repositoryState$.add(entities);
  }

  void addEntities(Iterable<T> entities) {
    if (entities.isEmpty) {
      throw '[Repository] List of entities (type $T) to add is empty';
    }
    final List<T> updatedEntities = [..._repositoryState$.value];
    for (final entity in entities) {
      final bool doesEntityExist = updatedEntities.firstWhereOrNull(
            (element) => element.id == entity.id,
          ) !=
          null;
      if (!doesEntityExist) updatedEntities.add(entity);
    }
    _repositoryState$.add(updatedEntities);
  }

  void updateEntity(T entity) {
    final List<T> entities = [..._repositoryState$.value];
    final int entityIndex = entities.indexWhere(
      (element) => element.id == entity.id,
    );
    if (entityIndex >= 0) {
      entities[entityIndex] = entity;
      _repositoryState$.add(entities);
    }
  }
}

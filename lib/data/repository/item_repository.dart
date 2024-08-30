import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

abstract class ItemRepository<T extends Equatable> {
  final BehaviorSubject<T?> _repositoryState$ =
      BehaviorSubject<T?>.seeded(null);

  Stream<T?> get repositoryState$ => _repositoryState$.stream;

  void updateState(T item) => _repositoryState$.add(item);
}

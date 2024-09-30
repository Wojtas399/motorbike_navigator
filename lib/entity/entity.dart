import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  final int id;

  const Entity({required this.id});
}

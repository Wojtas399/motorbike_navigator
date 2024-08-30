import 'package:equatable/equatable.dart';

enum SqlColumnType { id, integer, real, text }

class SqlColumn extends Equatable {
  final String name;
  final SqlColumnType type;
  final bool isNotNull;
  final String? foreignKeyReference;

  const SqlColumn({
    required this.name,
    required this.type,
    this.isNotNull = false,
    this.foreignKeyReference,
  });

  @override
  List<Object?> get props => [
        name,
        type,
        isNotNull,
        foreignKeyReference,
      ];
}

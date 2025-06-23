import 'package:parser/parser.dart';
import 'package:parser/model/opt.dart';

class Expression extends ManagedObject<_Expression> implements _Expression {
  @override
  void willInsert() {
    createdAt = DateTime.now().toUtc();
  }
}

class _Expression {
  @primaryKey
  int? id;

  @Column(indexed: true)
  String? expression;

  @Column(indexed: true)
  String? result;

  DateTime? createdAt;

  ManagedSet<Opt>? opts;
}

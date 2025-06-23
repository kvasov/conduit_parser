import 'package:parser/parser.dart';
import 'package:parser/model/model.dart';

class Opt extends ManagedObject<_Opt> implements _Opt {
  @override
  void willInsert() {
    createdAt = DateTime.now().toUtc();
  }
}

class _Opt {
  @primaryKey
  int? id;

  @Column(indexed: true)
  String? name;

  @Column(indexed: true)
  String? val;

  @Relate(#opts, onDelete: DeleteRule.cascade, isRequired: true)
  Expression? expression;

  DateTime? createdAt;
}

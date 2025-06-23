import 'package:parser/controller/parser.dart';
import 'package:parser/parser.dart';
import 'package:parser/model/model.dart';
import 'package:parser/model/opt.dart';
import 'package:logging/logging.dart';

class ExpressionAddController extends ResourceController {
  ExpressionAddController(this.context);
  final ManagedContext context;
  final Map<String, num> variables = {};

  @Operation.post()
  Future<Response> addModel() async {
    final body = await request!.body.decode();

    for (var variable in body['opts']) {
      variables.putIfAbsent(variable['name'], () => num.parse(variable['val']));
    }

    final parser = SimpleMathParser(body['expression'], variables);
    final expression = Expression()..read(body, ignore: ["id", "createdAt", "opts"]);

    try {
      final result = parser.evaluate();
      expression.result = result.toString();
    } catch (e) {
      expression.result = e.toString();
    }

    final expressionQuery = Query<Expression>(context)..values = expression;
    final insertedExpression = await expressionQuery.insert();

    final opts = (body["opts"] as List?) ?? [];
    final insertedOpts = <Opt>[];
    for (final optData in opts) {
      final opt = Opt()
        ..read(optData, ignore: ["id", "createdAt", "expression"])
        ..expression = insertedExpression;
      final optQuery = Query<Opt>(context)..values = opt;
      insertedOpts.add(await optQuery.insert());
    }

    return Response.ok({
      "expression": insertedExpression.asMap(),
      "opts": insertedOpts.map((o) => o.asMap()).toList(),
    });
  }
}
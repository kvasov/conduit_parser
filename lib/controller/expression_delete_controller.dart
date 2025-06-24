import 'package:parser/parser.dart';
import 'package:parser/model/model.dart';

class ExpressionDeleteController extends ResourceController {
  ExpressionDeleteController(this.context);
  final ManagedContext context;

  @Operation.delete('id')
  Future<Response> deleteModel(@Bind.path('id') int id) async {
    final query = Query<Expression>(context)..where((m) => m.id).equalTo(id);
    final count = await query.delete();
    if (count == 0) {
      return Response.notFound(body: {'message': 'Expression with id $id not found'});
    }
    return Response.ok({'deleted_count': count});
  }

  @Operation.get('id')
  Future<Response> deleteModelByGet(@Bind.path('id') int id) async {
    final query = Query<Expression>(context)..where((m) => m.id).equalTo(id);
    final count = await query.delete();
    if (count == 0) {
      return Response.notFound(
        body: '<html><body><h2>Expression with id $id not found</h2><a href="/parser/view">Back to list</a></body></html>'
      )..contentType = ContentType.html;
    }
    return Response.ok(
      '<html><body><h2>Expression with id $id deleted</h2><a href="/parser/view">Back to list</a></body></html>'
    )..contentType = ContentType.html;
  }
}
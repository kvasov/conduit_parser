import 'package:parser/parser.dart';
import 'package:parser/model/model.dart';

class ExpressionListController extends ResourceController {
  ExpressionListController(this.context);
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllModelsWithOpts() async {
    final query = Query<Expression>(context)..join(set: (m) => m.opts);
    final models = await query.fetch();

    final buffer = StringBuffer();
    buffer.writeln('<html>');
    buffer.writeln('<head><title>Models and Opts</title>');
    buffer.writeln('<style>');
    buffer.writeln(
        'table { font-family: sans-serif; border-collapse: collapse; width: 100%; }');
    buffer.writeln(
        'td, th { border: 1px solid #dddddd; text-align: left; padding: 8px; }');
    buffer.writeln('tr:nth-child(even) { background-color: #f2f2f2; }');
    buffer.writeln('</style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('<h1>List of expressions and results</h1>');
    buffer.writeln('<table>');
    buffer.writeln(
        '<tr><th>Expression (ID)</th><th>Variables (Name: Value)</th><th>Result</th><th>Delete</th></tr>');

    for (final model in models) {
      buffer.writeln('<tr>');
      buffer.writeln('<td>${model.expression} (ID: ${model.id})</td>');
      buffer.writeln('<td>');
      if (model.opts == null || model.opts!.isEmpty) {
        buffer.writeln('No associated opts.');
      } else {
        final optsList =
            model.opts!.map((opt) => '${opt.name}: ${opt.val}').join('<br>');
        buffer.writeln(optsList);
      }
      buffer.writeln('</td>');
      buffer.writeln('<td>${model.result}</td>');
      buffer.writeln('<td><a href="/parser/delete/${model.id}">Delete</a></td>');
      buffer.writeln('</tr>');
    }

    buffer.writeln('</table>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return Response.ok(buffer.toString())..contentType = ContentType.html;
  }
}
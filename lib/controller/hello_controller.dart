import 'package:parser/parser.dart';

class HelloController extends ResourceController {
  @Operation.get()
  Future<Response> sayHello() async {
    return Response.ok('hello world')..contentType = ContentType.text;
  }
}
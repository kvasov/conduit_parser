import 'package:parser/controller/expression_add_controller.dart';
import 'package:parser/controller/expression_delete_controller.dart';
import 'package:parser/controller/expression_list_controller.dart';
import 'package:parser/controller/hello_controller.dart';
import 'package:parser/model/model.dart';
import 'package:parser/parser.dart';
import 'package:conduit_core/conduit_core.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://www.theconduit.dev/docs/http/channel/.
class ParserChannel extends ApplicationChannel {
  late ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {

    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = ParserConfiguration(options!.configurationFilePath!);
    context = contextWithConnectionInfo(config.database!);

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database?.username,
        config.database?.password,
        config.database?.host,
        config.database?.port,
        config.database?.databaseName);

    context = ManagedContext(dataModel, psc);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router
        .route("/parser/[:id]")
        .link(() => ManagedObjectController<Expression>(context));
    router.route("/parser/add").link(() => ExpressionAddController(context));
    router.route("/parser/delete/:id").link(() => ExpressionDeleteController(context));
    router.route("/parser/view").link(() => ExpressionListController(context));
    router.route("/hello").link(() => HelloController());
    return router;
  }

  /*
   * Helper methods
   */

  ManagedContext contextWithConnectionInfo(
      DatabaseConfiguration connectionInfo) {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore(
        connectionInfo.username,
        connectionInfo.password,
        connectionInfo.host,
        connectionInfo.port,
        connectionInfo.databaseName);

    return ManagedContext(dataModel, psc);
  }
}

/// An instance of this class reads values from a configuration
/// file specific to this application.
///
/// Configuration files must have key-value for the properties in this class.
/// For more documentation on configuration files, see https://www.theconduit.dev/docs/configure/ and
/// https://pub.dartlang.org/packages/safe_config.
class ParserConfiguration extends Configuration {
  ParserConfiguration(String fileName) : super.fromFile(File(fileName));

  DatabaseConfiguration? database;
}

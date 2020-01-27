import 'dart:async';
import 'dart:convert';
import 'package:aqueduct/aqueduct.dart';
import 'airline_controller.dart';

class AirlineApiChannel extends ApplicationChannel {

  ManagedContext context;

  @override
  Future prepare() async {
    /* configure the sql connection */
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      'postgres', 'password', 'localhost', 5432, 'AirlineDatabase');
    context = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final Router router = Router();
    // route for get all airline information
    router
      .route('/airline/get-airlines')
      .linkFunction((request) => AirlineController(context).getAirlines());
      // route for getting all flight information
    router
      .route('/airline/get-flights')
      .linkFunction((request) => AirlineController(context).getFlights());
      // route for getting flights by their foreign key id (airlineid)
    router
      .route('/airline/get-flights-by-id')
      .linkFunction((request) async {
        print(request.response.statusCode);
        final map = await request.body.decode() as Map<String, dynamic>;
        print(map['id']);
        return AirlineController(context).getFlightByAirlineID(map['id'] as int);
      });
    return router;
  }
}
import 'dart:async';
import 'package:airline_api/airline/airline_api.dart';
import 'package:aqueduct/aqueduct.dart';
import 'airline_model.dart';

class AirlineController extends ResourceController {
  AirlineController(this.context);

  final ManagedContext context;

  /* function for mapping Airline model to database entity */
  @Operation.get()
  Future<Response> getAirlines() async {
    final query = Query<AlirlineModel>(context);
    return Response.ok(await query.fetch());
  }

  /* function for mapping Flight model to database entity */
  @Operation.get()
  Future<Response> getFlights() async {
    final query = Query<FlightModel>(context);
    print(request.body);
    return Response.ok(await query.fetch());
  }

  @Operation.post()
  Future<Response> getFlightByAirlineID(@Bind.body(require: ["id"]) int id) async {
    final flightQuery = Query<FlightModel>(context)
    ..where((f) => f.flight_fk_airlineid).equalTo(id);   
    if (flightQuery == null) {
      return Response.notFound();
    }
    return Response.ok(flightQuery)..contentType = ContentType.json;
  }
}
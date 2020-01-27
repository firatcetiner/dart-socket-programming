import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:hotel_api/hotel/hotel_api.dart';
import 'hotel_model.dart';

class HotelController extends ResourceController {
  HotelController(this.context);

  final ManagedContext context;

  /* function for mapping the application model for database entity */
  @Operation.get()
  Future<Response> getHotels() async {
    final query = Query<HotelModel>(context);
    return Response.ok(await query.fetch());
  }
}
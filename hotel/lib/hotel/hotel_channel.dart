import 'package:hotel_api/hotel/hotel_controller.dart';
import 'hotel_api.dart';


class HotelApiChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      'postgres', 'password', 'localhost', 5432, 'HotelDatabase');
    context = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
  }
  /* create a route for getting the whole hotel information from the database */
  @override
  Controller get entryPoint {
    final Router route = Router();
    route
      .route('/hotel/get-hotels')
      .link(() => HotelController(context));
    return route;
  }
}
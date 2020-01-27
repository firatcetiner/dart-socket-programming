import 'package:aqueduct/aqueduct.dart';

class HotelModel extends ManagedObject<Hotel> implements Hotel {}

class Hotel {
  @primaryKey
  int hotelid;

  @Column(unique: true)
  String hotelname;
  int avaiblerooms;
}
import 'package:aqueduct/aqueduct.dart';

class AlirlineModel extends ManagedObject<Airline> implements Airline {}

class Airline {
  @primaryKey
  int airlineid;
  @Column(unique: true)
  String airlinename;
}

class FlightModel extends ManagedObject<Flight> implements Flight {}

class Flight {
  @primaryKey
  int flightid;
  
  @Column(unique: true)
  int flight_fk_airlineid;
  String airlinename;
  DateTime flightarrival;
  DateTime flightdeparture;
  int flightcapacity;
  int reservedseats;
  int flightfull;
  
}
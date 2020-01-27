import 'package:hotel_api/hotel/hotel_api.dart';

Future main() async {
  // configure the application port
  final hotelApp = Application<HotelApiChannel>()..options.port = 8887;

  // configure the number of threads running
  final count = Platform.numberOfProcessors ~/ 2;
  await hotelApp.start(numberOfInstances: count > 0 ? count : 1);
  
  print("Hotel Application started on port: ${hotelApp.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
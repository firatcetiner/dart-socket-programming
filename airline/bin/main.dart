import 'package:airline_api/airline/airline_api.dart';

Future main() async {
  final airlineApp = Application<AirlineApiChannel>()..options.port = 8888;

  final count = Platform.numberOfProcessors ~/ 2;
  await airlineApp.start(numberOfInstances: count > 0 ? count : 1);
  
  print("Airline Application started on port: ${airlineApp.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
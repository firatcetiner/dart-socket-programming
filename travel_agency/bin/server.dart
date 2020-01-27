import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  await ServerSocket.bind('10.20.13.240', 8080).then((server) { 
    sendInitialData(server);
  });
  await ServerSocket.bind('10.20.13.240', 8081).then((server) {
    handleTripInformationFromClient(server);
  });
}

void sendInitialData(ServerSocket server) {
  var codec = Utf8Codec(allowMalformed: false);
  server.listen((Socket client) {
    getAirlines().then((airlines) {
      getHotels().then((hotels) {
        final results = jsonEncode({
          'hotels': hotels,
          'airlines': airlines
        });
        client.add(codec.encode(results));
      });
    });
    //client.close();
  });
}

void handleTripInformationFromClient(ServerSocket server) {
  var codec = Utf8Codec(allowMalformed: false);
  server.listen((Socket client) {
    client.listen((data) {
      final preferred = jsonDecode(String.fromCharCodes(data));
      getFlights().then((response) {
        for(var flight in response) {
          if(preferred['airline'] == flight['airlinename']) {
            print('OK');
          }
        }
      });
    });
  });
}

Future<List<dynamic>> getHotels() async {
  final response = await http.get('http://localhost:8887/hotel/get-hotels');
  print(response.statusCode);
  if(response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

Future<List<dynamic>> getFlights() async {
  final response = await http.get('http://localhost:8888/airline/get-flights');
  if(response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

Future<List<dynamic>> getAirlines() async {
  final response = await http.get('http://localhost:8888/airline/get-airlines');
  print(response.statusCode);
  if(response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

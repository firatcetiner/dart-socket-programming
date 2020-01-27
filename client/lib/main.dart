import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'airline_model.dart';
import 'hotel_model.dart';
import 'package:http/http.dart' as http;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime _selectedDeparture = DateTime.now();
  DateTime _selectedArrival = DateTime.now();
  String _selectedAirline;
  String _selectedHotel;
  int _numberOfTravelers = 0;

  var hotels = List<Hotel>();
  var airlines = List<Airline>();
  TextEditingController _textEditingController = TextEditingController(text: '0');

  @override
  void initState() {
    if(mounted) initializeData();
    super.initState();
  }


  void _showHotels(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a hotel:', style: TextStyle(color: Colors.blue)
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          content: hotels.length != 0 ? SizedBox() : Container()
        );
      }
    );
  }

  void _showAirlines(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          title: Row(
            children: <Widget>[
              Icon(Icons.airplanemode_active, color: Colors.blue,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('Select an airline: ', style: TextStyle(color: Colors.blue))
              ),
            ],
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          content: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: airlines.length != 0 ? ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemCount: airlines.length,
                itemBuilder: (context, index) {
                  return Text(airlines[index].airlinename);
                },
              ) : Container(),
            ),
          )
        );
      }
    );
  }

  Future<Null> _selectDeparture(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeparture,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025)
    );
    if(picked != null && picked != _selectedDeparture) {
      setState(() {
        _selectedDeparture = picked;
      });
    }
  }
    Future<Null> _selectArrival(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedArrival,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025)
    );
    if(picked != null && picked != _selectedArrival) {
      setState(() {
        _selectedArrival = picked;
      });
    }
  }

  Future<Null> initializeData() {
    Socket.connect('10.20.13.240', 8080).then((client) {
      client.listen((data) {
        setState(() {
        var decodedResponse = jsonDecode(String.fromCharCodes(data));
         hotels = decodedResponse['hotels']
          .map<Hotel>((json) => Hotel.fromJson(json)).toList();
         airlines = decodedResponse['airlines']
          .map<Airline>((json) => Airline.fromJson(json)).toList();
        });
        _selectedAirline = airlines[0].airlinename;
        _selectedHotel = hotels[0].hotelname;
      });
      for(var a in hotels)
        print(a.hotelname);
      client.close();
    });
    return null;
  }

  Future<void> sampleReq() async {
    final response = await http.post(
      'http://10.20.13.240:8888/airline/get-flights-by-id',
      body: jsonEncode({
        "id": 51
      }),
      headers: {
        "content-type": "application/json"
      }
    );
    print(jsonDecode(response.body));
  }

  Future<Null> sendData() {
    final tripInfo = jsonEncode({
      'departure': '${_selectedDeparture.year}-${_selectedDeparture.month}-${_selectedDeparture.day}',
      'arrival': '${_selectedArrival.year}-${_selectedArrival.month}-${_selectedArrival.day}',
      'hotel': '$_selectedHotel',
      'airline': '$_selectedAirline',
      'numberoftravelers': _numberOfTravelers
    });
    Utf8Codec codec = Utf8Codec();
    Socket.connect('192.168.1.45', 8081).then((client) {
      client.add(codec.encode(tripInfo));
      client.listen((data) {
        print(jsonDecode(String.fromCharCodes(data))['flights'][6]);
      });
      client.close();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (scroll) {
        scroll.disallowGlow();
        return false;
      },
      child: Scaffold( 
        appBar: AppBar(
          title: Text('Travel Agency'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            initializeData();
            return Future.delayed(Duration(milliseconds: 300));
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: <Widget>[
              GestureDetector(
                onTap: () => _selectDeparture(context),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[300], spreadRadius: 0.2, blurRadius: 5.0)
                        ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.9),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                            ),
                            child: Center(child: Text('Departure Date', style: TextStyle(color: Colors.white),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.calendar_today),
                                Text(
                                  '${_selectedDeparture.year}-${_selectedDeparture.month}-${_selectedDeparture.day}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _selectArrival(context),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300], spreadRadius: 0.2, blurRadius: 5.0)
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.9),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                        ),
                        child: Center(child: Text('Arrival Date', style: TextStyle(color: Colors.white),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.calendar_today),
                            Text(
                              '${_selectedArrival.year}-${_selectedArrival.month}-${_selectedArrival.day}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showHotels(context),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300], spreadRadius: 0.2, blurRadius: 5.0)
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.9),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                        ),
                        child: Center(child: Text('Preferred Hotel', style: TextStyle(color: Colors.white),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.local_hotel),
                            Text(
                              hotels.length != 0 ? '$_selectedHotel' : 'hotels',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showAirlines(context),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300], spreadRadius: 0.2, blurRadius: 5.0)
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.9),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                        ),
                        child: Center(child: Text('Preferred Airline', style: TextStyle(color: Colors.white),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.airplanemode_active),
                            Text(
                              airlines.length != 0 ? '$_selectedAirline' : 'airline',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 110),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 0.2,
                      blurRadius: 5.0
                    )
                  ]
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.9),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))
                      ),
                      child: Center(
                        child: Text(
                          'Number of Travelers',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if(_numberOfTravelers > 0) {
                                _numberOfTravelers--;
                                _textEditingController.text = _numberOfTravelers.toString();
                              }
                            });
                          },
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: _textEditingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration.collapsed(
                                hintText: '${_textEditingController.text}'
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          color: Colors.blue,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _numberOfTravelers++;
                              _textEditingController.text = _numberOfTravelers.toString();
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.search),
                  label: Text('Search for a trip'),
                  onPressed: () async {
                    sendData();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

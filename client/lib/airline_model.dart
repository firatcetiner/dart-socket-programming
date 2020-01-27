class Airline {
  int airlineid;
  String airlinename;

  Airline({this.airlineid, this.airlinename});

  Airline.fromJson(Map<String, dynamic> json) {
    airlineid = json['hotelid'];
    airlinename = json['airlinename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['airlineid'] = this.airlineid;
    data['airlinename'] = this.airlinename;
    return data;
  }
}
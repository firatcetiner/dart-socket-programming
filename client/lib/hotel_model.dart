class Hotel {
  int hotelid;
  String hotelname;
  int avaiblerooms;

  Hotel({this.hotelid, this.hotelname, this.avaiblerooms});

  Hotel.fromJson(Map<String, dynamic> json) {
    hotelid = json['hotelid'];
    hotelname = json['hotelname'];
    avaiblerooms = json['avaiblerooms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['hotelid'] = this.hotelid;
    data['hotelname'] = this.hotelname;
    data['avaiblerooms'] = this.avaiblerooms;
    return data;
  }
}
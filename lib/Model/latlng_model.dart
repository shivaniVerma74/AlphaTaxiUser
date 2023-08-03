class LatLngModel {
  String? id;
  String? driverId;
  String? bookingId;
  double? lat;
  double? lang;

  LatLngModel({this.id, this.driverId, this.bookingId, this.lat, this.lang});

  LatLngModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    bookingId = json['booking_id'];
    lat = json['lat'] != null && double.parse(json['lat']) > 0
        ? double.parse(json['lat'])
        : 0;
    lang = json['lang'] != null && double.parse(json['lang']) > 0
        ? double.parse(json['lang'])
        : 75.8623047;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['booking_id'] = this.bookingId;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    return data;
  }
}

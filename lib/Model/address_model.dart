class AddressModel {
  String? id;
  String? userId;
  String? area;
  String? pickupAddress;
  String? landmark;
  String? lat;
  String? lang;
  String? type;

  AddressModel(
      {this.id,
      this.userId,
      this.area,
      this.pickupAddress,
      this.landmark,
      this.lat,
      this.lang,
      this.type});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    area = json['area'];
    pickupAddress = json['pickup_address'];
    landmark = json['landmark'];
    lat = json['lat'];
    lang = json['lang'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['area'] = this.area;
    data['pickup_address'] = this.pickupAddress;
    data['landmark'] = this.landmark;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['type'] = this.type;
    return data;
  }
}

import 'dart:convert';
/// status : true
/// message : "Cab Detail"
/// data : [{"cartype":"Mini","intialkm":"4","intailrate":177,"image":"https://gnhub.net/zappy/assets/upload/car/1574753897.png"},{"cartype":"Sedan","intialkm":"4","intailrate":212.39999999999998,"image":"https://gnhub.net/zappy/assets/upload/car/1574753795.png"}]

RideModel rideModelFromJson(String str) => RideModel.fromJson(json.decode(str));
String rideModelToJson(RideModel data) => json.encode(data.toJson());
class RideModel {
  RideModel({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  RideModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;
RideModel copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => RideModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// cartype : "Mini"
/// intialkm : "4"
/// intailrate : 177
/// image : "https://gnhub.net/zappy/assets/upload/car/1574753897.png"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? cartype, 
      String? intialkm, 
      dynamic intailrate,
      String? image,}){
    _cartype = cartype;
    _intialkm = intialkm;
    _intailrate = intailrate;
    _image = image;
}

  Data.fromJson(dynamic json) {
    _cartype = json['cartype'];
    _intialkm = json['intialkm'];
    _intailrate = json['intailrate'];
    _image = json['image'];
  }
  String? _cartype;
  String? _intialkm;
  dynamic _intailrate;
  String? _image;
Data copyWith({  String? cartype,
  String? intialkm,
  dynamic intailrate,
  String? image,
}) => Data(  cartype: cartype ?? _cartype,
  intialkm: intialkm ?? _intialkm,
  intailrate: intailrate ?? _intailrate,
  image: image ?? _image,
);
  String? get cartype => _cartype;
  String? get intialkm => _intialkm;
  dynamic get intailrate => _intailrate;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cartype'] = _cartype;
    map['intialkm'] = _intialkm;
    map['intailrate'] = _intailrate;
    map['image'] = _image;
    return map;
  }

}
import 'dart:convert';
/// status : true
/// message : "Your Password Has Changed successfully"

ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));
String changePasswordModelToJson(ChangePasswordModel data) => json.encode(data.toJson());
class ChangePasswordModel {
  ChangePasswordModel({
      bool? status, 
      String? message,}){
    _status = status;
    _message = message;
}

  ChangePasswordModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  bool? _status;
  String? _message;
ChangePasswordModel copyWith({  bool? status,
  String? message,
}) => ChangePasswordModel(  status: status ?? _status,
  message: message ?? _message,
);
  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}
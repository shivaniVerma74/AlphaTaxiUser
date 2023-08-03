class RestaurantModel {
  String? id;
  String? userStatus;
  String? userName;
  String? email;
  String? phone;
  String? accountNumber;
  String? bankName;
  String? ifscCode;
  List<String>? userImage;
  String? userAddress;
  String? address;
  String? lat;
  String? lang;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? openTime;
  String? closeTime;
  String? ownerName;
  int? openClose;
  String? ratting;
  String? rowOrder;
  double? distance;

  RestaurantModel(
      {this.id,
      this.userStatus,
      this.userName,
      this.email,
      this.phone,
      this.accountNumber,
      this.bankName,
      this.ifscCode,
      this.userImage,
      this.userAddress,
      this.address,
      this.lat,
      this.lang,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.openTime,
      this.closeTime,
      this.ownerName,
      this.openClose,
      this.ratting,
      this.rowOrder,
      this.distance});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userStatus = json['user_status'];
    userName = json['user_name'];
    email = json['email'];
    phone = json['phone'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    userImage = json['user_image'].cast<String>();
    userAddress = json['user_address'];
    address = json['address'];
    lat = json['lat'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    ownerName = json['owner_name'];
    openClose = json['open_close'];
    ratting = json['ratting'];
    rowOrder = json['row_order'];
    distance = double.tryParse(json['distance']) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_status'] = this.userStatus;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['account_number'] = this.accountNumber;
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['user_image'] = this.userImage;
    data['user_address'] = this.userAddress;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['owner_name'] = this.ownerName;
    data['open_close'] = this.openClose;
    data['ratting'] = this.ratting;
    data['row_order'] = this.rowOrder;
    data['distance'] = this.distance;
    return data;
  }
}

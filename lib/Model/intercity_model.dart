class IntercityRideModel {
  String? id;
  String? userId;
  String? uneaqueId;
  int? selectedUser;
  String? purpose;
  String? pickupArea;
  String? pickupDate;
  String? dropArea;
  String? pickupTime;
  String? area;
  String? landmark;
  String? pickupAddress;
  String? dropAddress;
  String? taxiType;
  String? car_no;
  String? departureTime;
  String? departureDate;
  String? returnDate;
  String? flightNumber;
  String? package;
  String? promoCode;
  String? distance;
  String? amount;
  String? paidAmount;
  String? address;
  String? transfer;
  String? itemStatus;
  String? transaction;
  String? paymentMedia;
  String? km;
  String? timetype;
  String? assignedFor;
  String? isPaidAdvance;
  String? status;
  String? latitude;
  String? longitude;
  String? dateAdded;
  String? dropLatitude;
  String? dropLongitude;
  String? bookingType;
  String? acceptReject;
  String? createdDate;
  String? username;
  String? reason;
  String? surgeAmount;
  String? gstAmount;
  String? baseFare;
  String? timeAmount;
  String? ratePerKm;
  String? adminCommision;
  String? totalTime;
  String? cancelCharge;
  String? carCategories;
  String? startTime;
  String? endTime;
  String? taxiId;
  String? hours;
  String? bookingTime;
  String? shareingType;
  String? sharingUserId;
  String? promoDiscount;
  String? paymentStatus;
  String? bookingOtp;
  String? deliveryType;
  String? otpStatus;
  String? extraTimeCharge;
  String? extraKmCharge;
  String? pickupCity;
  String? dropCity;
  String? addOnCharge;
  String? addOnTime;
  String? addOnDistance;
  String? bookLatitude;
  String? bookLongitude;
  String? bookingId;
  String? mobile;
  String? email;
  String? gender;
  String? dob;
  String? anniversaryDate;
  String? password;
  String? pickupadd;
  String? activeId;
  String? userStatus;
  String? resetId;
  String? walletAmount;
  String? deviceId;
  String? type;
  String? otp;
  String? userGcmCode;
  String? created;
  String? modified;
  String? userImage;
  String? referralCode;
  String? friendsCode;
  String? longnitute;
  String? newPassword;
  String? firstOrder;
  String? driverName;
  String? driverId;
  String? driverImage;
  String? driverContact;
  List<ShareUserData>? shareUserData;
  bool? show;
  IntercityRideModel(
      {this.id,
      this.userId,
      this.selectedUser,
      this.show,
      this.uneaqueId,
      this.car_no,
      this.purpose,
      this.pickupArea,
      this.pickupDate,
      this.dropArea,
      this.pickupTime,
      this.area,
      this.landmark,
      this.pickupAddress,
      this.dropAddress,
      this.taxiType,
      this.departureTime,
      this.departureDate,
      this.returnDate,
      this.flightNumber,
      this.package,
      this.promoCode,
      this.distance,
      this.amount,
      this.paidAmount,
      this.address,
      this.transfer,
      this.itemStatus,
      this.transaction,
      this.paymentMedia,
      this.km,
      this.timetype,
      this.assignedFor,
      this.isPaidAdvance,
      this.status,
      this.latitude,
      this.longitude,
      this.dateAdded,
      this.dropLatitude,
      this.dropLongitude,
      this.bookingType,
      this.acceptReject,
      this.createdDate,
      this.username,
      this.reason,
      this.surgeAmount,
      this.gstAmount,
      this.baseFare,
      this.timeAmount,
      this.ratePerKm,
      this.adminCommision,
      this.totalTime,
      this.cancelCharge,
      this.carCategories,
      this.startTime,
      this.endTime,
      this.taxiId,
      this.hours,
      this.bookingTime,
      this.shareingType,
      this.sharingUserId,
      this.promoDiscount,
      this.paymentStatus,
      this.bookingOtp,
      this.deliveryType,
      this.otpStatus,
      this.extraTimeCharge,
      this.extraKmCharge,
      this.pickupCity,
      this.dropCity,
      this.addOnCharge,
      this.addOnTime,
      this.addOnDistance,
      this.bookLatitude,
      this.bookLongitude,
      this.bookingId,
      this.mobile,
      this.email,
      this.gender,
      this.dob,
      this.anniversaryDate,
      this.password,
      this.pickupadd,
      this.activeId,
      this.userStatus,
      this.resetId,
      this.walletAmount,
      this.deviceId,
      this.type,
      this.otp,
      this.userGcmCode,
      this.created,
      this.modified,
      this.userImage,
      this.referralCode,
      this.friendsCode,
      this.longnitute,
      this.newPassword,
      this.firstOrder,
      this.driverName,
      this.driverId,
      this.driverImage,
      this.driverContact,
      this.shareUserData});

  IntercityRideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    car_no = json['car_no'];
    uneaqueId = json['uneaque_id'];
    purpose = json['purpose'];
    pickupArea = json['pickup_area'];
    pickupDate = json['pickup_date'];
    dropArea = json['drop_area'];
    pickupTime = json['pickup_time'];
    area = json['area'];
    landmark = json['landmark'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    taxiType = json['taxi_type'];
    departureTime = json['departure_time'];
    departureDate = json['departure_date'];
    returnDate = json['return_date'];
    flightNumber = json['flight_number'];
    package = json['package'];
    promoCode = json['promo_code'];
    distance = json['distance'];
    amount = json['amount'];
    paidAmount = json['paid_amount'];
    address = json['address'];
    transfer = json['transfer'];
    itemStatus = json['item_status'];
    transaction = json['transaction'];
    paymentMedia = json['payment_media'];
    km = json['km'];
    timetype = json['timetype'];
    assignedFor = json['assigned_for'];
    isPaidAdvance = json['is_paid_advance'];
    status = json['status'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dateAdded = json['date_added'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    bookingType = json['booking_type'];
    acceptReject = json['accept_reject'];
    createdDate = json['created_date'];
    username = json['username'];
    reason = json['reason'];
    surgeAmount = json['surge_amount'];
    gstAmount = json['gst_amount'];
    baseFare = json['base_fare'];
    timeAmount = json['time_amount'];
    ratePerKm = json['rate_per_km'];
    adminCommision = json['admin_commision'];
    totalTime = json['total_time'];
    cancelCharge = json['cancel_charge'];
    carCategories = json['car_categories'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    taxiId = json['taxi_id'];
    hours = json['hours'];
    bookingTime = json['booking_time'];
    shareingType = json['shareing_type'];
    sharingUserId = json['sharing_user_id'];
    promoDiscount = json['promo_discount'];
    paymentStatus = json['payment_status'];
    bookingOtp = json['booking_otp'];
    deliveryType = json['delivery_type'];
    otpStatus = json['otp_status'];
    extraTimeCharge = json['extra_time_charge'];
    extraKmCharge = json['extra_km_charge'];
    pickupCity = json['pickup_city'];
    dropCity = json['drop_city'];
    addOnCharge = json['add_on_charge'];
    addOnTime = json['add_on_time'];
    addOnDistance = json['add_on_distance'];
    bookLatitude = json['book_latitude'];
    bookLongitude = json['book_longitude'];
    bookingId = json['booking_id'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    anniversaryDate = json['anniversary_date'];
    password = json['password'];
    pickupadd = json['pickupadd'];
    activeId = json['active_id'];
    userStatus = json['user_status'];
    resetId = json['reset_id'];
    walletAmount = json['wallet_amount'];
    deviceId = json['device_id'];
    type = json['type'];
    otp = json['otp'];
    userGcmCode = json['user_gcm_code'];
    created = json['created'];
    modified = json['modified'];
    userImage = json['user_image'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    longnitute = json['longnitute'];
    newPassword = json['new_password'];
    firstOrder = json['first_order'];
    driverName = json['driver_name'];
    driverId = json['driver_id'];
    driverImage = json['driver_image'];
    driverContact = json['driver_contact'];
    show = true;
    if (json['share_user_data'] != String) {
      shareUserData = <ShareUserData>[];
      json['share_user_data'].forEach((v) {
        shareUserData!.add(new ShareUserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['uneaque_id'] = this.uneaqueId;
    data['purpose'] = this.purpose;
    data['pickup_area'] = this.pickupArea;
    data['pickup_date'] = this.pickupDate;
    data['drop_area'] = this.dropArea;
    data['pickup_time'] = this.pickupTime;
    data['area'] = this.area;
    data['landmark'] = this.landmark;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['taxi_type'] = this.taxiType;
    data['departure_time'] = this.departureTime;
    data['departure_date'] = this.departureDate;
    data['return_date'] = this.returnDate;
    data['flight_number'] = this.flightNumber;
    data['package'] = this.package;
    data['promo_code'] = this.promoCode;
    data['distance'] = this.distance;
    data['amount'] = this.amount;
    data['paid_amount'] = this.paidAmount;
    data['address'] = this.address;
    data['transfer'] = this.transfer;
    data['item_status'] = this.itemStatus;
    data['transaction'] = this.transaction;
    data['payment_media'] = this.paymentMedia;
    data['km'] = this.km;
    data['timetype'] = this.timetype;
    data['assigned_for'] = this.assignedFor;
    data['is_paid_advance'] = this.isPaidAdvance;
    data['status'] = this.status;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['date_added'] = this.dateAdded;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['booking_type'] = this.bookingType;
    data['accept_reject'] = this.acceptReject;
    data['created_date'] = this.createdDate;
    data['username'] = this.username;
    data['reason'] = this.reason;
    data['surge_amount'] = this.surgeAmount;
    data['gst_amount'] = this.gstAmount;
    data['base_fare'] = this.baseFare;
    data['time_amount'] = this.timeAmount;
    data['rate_per_km'] = this.ratePerKm;
    data['admin_commision'] = this.adminCommision;
    data['total_time'] = this.totalTime;
    data['cancel_charge'] = this.cancelCharge;
    data['car_categories'] = this.carCategories;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['taxi_id'] = this.taxiId;
    data['hours'] = this.hours;
    data['booking_time'] = this.bookingTime;
    data['shareing_type'] = this.shareingType;
    data['sharing_user_id'] = this.sharingUserId;
    data['promo_discount'] = this.promoDiscount;
    data['payment_status'] = this.paymentStatus;
    data['booking_otp'] = this.bookingOtp;
    data['delivery_type'] = this.deliveryType;
    data['otp_status'] = this.otpStatus;
    data['extra_time_charge'] = this.extraTimeCharge;
    data['extra_km_charge'] = this.extraKmCharge;
    data['pickup_city'] = this.pickupCity;
    data['drop_city'] = this.dropCity;
    data['add_on_charge'] = this.addOnCharge;
    data['add_on_time'] = this.addOnTime;
    data['add_on_distance'] = this.addOnDistance;
    data['book_latitude'] = this.bookLatitude;
    data['book_longitude'] = this.bookLongitude;
    data['booking_id'] = this.bookingId;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['anniversary_date'] = this.anniversaryDate;
    data['password'] = this.password;
    data['pickupadd'] = this.pickupadd;
    data['active_id'] = this.activeId;
    data['user_status'] = this.userStatus;
    data['reset_id'] = this.resetId;
    data['wallet_amount'] = this.walletAmount;
    data['device_id'] = this.deviceId;
    data['type'] = this.type;
    data['otp'] = this.otp;
    data['user_gcm_code'] = this.userGcmCode;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['user_image'] = this.userImage;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['longnitute'] = this.longnitute;
    data['new_password'] = this.newPassword;
    data['first_order'] = this.firstOrder;
    data['driver_name'] = this.driverName;
    data['driver_id'] = this.driverId;
    data['driver_image'] = this.driverImage;
    data['driver_contact'] = this.driverContact;
    if (this.shareUserData != String) {
      data['share_user_data'] =
          this.shareUserData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShareUserData {
  String? id;
  String? userId;
  String? bookingId;
  String? promoDiscount;
  String? totalAmount;
  String? otp;
  String? latitude;
  String? longitude;
  String? pickupAddress;
  String? dropAddress;
  String? dropLatitude;
  String? dropLongitude;
  String? pickupStatus;
  String? driverId;
  String? rideotp;
  String? mobile;
  String? email;
  String? gender;
  String? dob;
  String? anniversaryDate;
  String? password;
  String? pickupadd;
  String? activeId;
  String? userStatus;
  String? resetId;
  String? walletAmount;
  String? deviceId;
  String? type;
  String? userGcmCode;
  String? otpStatus;
  String? created;
  String? modified;
  String? userImage;
  String? referralCode;
  String? friendsCode;
  String? longnitute;
  String? username;
  String? newPassword;
  String? firstOrder;

  ShareUserData(
      {this.id,
      this.userId,
      this.bookingId,
      this.promoDiscount,
      this.totalAmount,
      this.otp,
      this.latitude,
      this.longitude,
      this.pickupAddress,
      this.dropAddress,
      this.dropLatitude,
      this.dropLongitude,
      this.pickupStatus,
      this.driverId,
      this.rideotp,
      this.mobile,
      this.email,
      this.gender,
      this.dob,
      this.anniversaryDate,
      this.password,
      this.pickupadd,
      this.activeId,
      this.userStatus,
      this.resetId,
      this.walletAmount,
      this.deviceId,
      this.type,
      this.userGcmCode,
      this.otpStatus,
      this.created,
      this.modified,
      this.userImage,
      this.referralCode,
      this.friendsCode,
      this.longnitute,
      this.username,
      this.newPassword,
      this.firstOrder});

  ShareUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    promoDiscount = json['promo_discount'];
    totalAmount = json['total_amount'];
    otp = json['otp'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    pickupStatus = json['pickup_status'];
    driverId = json['driver_id'];
    rideotp = json['rideotp'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    anniversaryDate = json['anniversary_date'];
    password = json['password'];
    pickupadd = json['pickupadd'];
    activeId = json['active_id'];
    userStatus = json['user_status'];
    resetId = json['reset_id'];
    walletAmount = json['wallet_amount'];
    deviceId = json['device_id'];
    type = json['type'];
    userGcmCode = json['user_gcm_code'];
    otpStatus = json['otp_status'];
    created = json['created'];
    modified = json['modified'];
    userImage = json['user_image'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    longnitute = json['longnitute'];
    username = json['username'];
    newPassword = json['new_password'];
    firstOrder = json['first_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['booking_id'] = this.bookingId;
    data['promo_discount'] = this.promoDiscount;
    data['total_amount'] = this.totalAmount;
    data['otp'] = this.otp;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['pickup_status'] = this.pickupStatus;
    data['driver_id'] = this.driverId;
    data['rideotp'] = this.rideotp;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['anniversary_date'] = this.anniversaryDate;
    data['password'] = this.password;
    data['pickupadd'] = this.pickupadd;
    data['active_id'] = this.activeId;
    data['user_status'] = this.userStatus;
    data['reset_id'] = this.resetId;
    data['wallet_amount'] = this.walletAmount;
    data['device_id'] = this.deviceId;
    data['type'] = this.type;
    data['user_gcm_code'] = this.userGcmCode;
    data['otp_status'] = this.otpStatus;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['user_image'] = this.userImage;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['longnitute'] = this.longnitute;
    data['username'] = this.username;
    data['new_password'] = this.newPassword;
    data['first_order'] = this.firstOrder;
    return data;
  }
}

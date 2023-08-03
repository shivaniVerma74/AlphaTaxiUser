class MyRideModel {
  String? id;
  String? userId;
  String? username;
  String? taxiId;
  String? uneaqueId;
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
  String? bookingOtp;
  String? userGcmCode;
  String? otpStatus;
  String? created;
  String? modified;
  String? userImage;
  String? referralCode;
  String? friendsCode;
  String? longnitute;
  String? driverName;
  String? driverId;
  String? driverImage;
  String? driverContact;
  String? baseFare;
  String? ratePerKm;
  String? timeAmount;
  String? surgeAmount;
  String? gstAmount;
  String? rating;
  String? driveLat;
  String? driveLng;
  String? car_no;
  String? totalTime;
  String? cancel_charge;
  String? hours;
  String? start_time, end_time;
  String? extra_time_charge, extra_km_charge;
  String? sharing_type;
  String? promo_discount;
  String? payment_status, add_on_charge, add_on_time, add_on_distance;
  bool? show;
  MyRideModel(
      {this.id,
      this.userId,
      this.hours,
      this.payment_status,
      this.add_on_charge,
      this.add_on_time,
      this.add_on_distance,
      this.extra_km_charge,
      this.extra_time_charge,
      this.promo_discount,
      this.start_time,
      this.end_time,
      this.username,
      this.uneaqueId,
      this.purpose,
      this.totalTime,
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
      this.bookingOtp,
      this.userGcmCode,
      this.otpStatus,
      this.created,
      this.modified,
      this.userImage,
      this.referralCode,
      this.friendsCode,
      this.longnitute,
      this.driverName,
      this.driverId,
      this.driverImage,
      this.driverContact,
      this.gstAmount,
      this.surgeAmount,
      this.baseFare,
      this.ratePerKm,
      this.timeAmount,
      this.show,
      this.driveLat,
      this.driveLng,
      this.rating,
      this.car_no,
      this.cancel_charge,
      this.sharing_type});

  MyRideModel.fromJson(Map<String, dynamic> json) {
    id = json['booking_id'] != null ? json['booking_id'] : json['id'];
    userId = json['user_id'];
    payment_status = json['payment_status'];
    add_on_charge = json['add_on_charge'];
    add_on_distance = json['add_on_distance'];
    add_on_time = json['add_on_time'];
    sharing_type = json['shareing_type'];
    promo_discount =
        json['promo_discount'] != null && json['promo_discount'] != ""
            ? json['promo_discount']
            : "0";
    extra_time_charge = json['extra_time_charge'];
    extra_km_charge = json['extra_km_charge'];
    totalTime = json['total_time'];
    username = json['username'];
    hours = json['hours'];
    start_time = json['start_time'];
    end_time = json['end_time'];
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
    latitude = json['book_latitude'];
    longitude = json['book_longitude'];
    dateAdded = json['date_added'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    bookingType = json['booking_type'];
    acceptReject = json['accept_reject'];
    createdDate = json['created_date'];
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
    taxiId = json['taxi_id'];
    walletAmount = json['wallet_amount'];
    deviceId = json['device_id'];
    type = json['type'];
    otp = json['otp'];
    bookingOtp = json['booking_otp'];
    userGcmCode = json['user_gcm_code'];
    otpStatus = json['otp_status'];
    created = json['created'];
    modified = json['modified'];
    userImage = json['user_image'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    longnitute = json['longnitute'];
    driverName = json['driver_name'];
    driverId = json['driver_id'];
    driverImage = json['driver_image'];
    driverContact = json['driver_contact'];
    baseFare = json['base_fare'];
    timeAmount = json['time_amount'];
    ratePerKm = json['rate_per_km'];
    surgeAmount = json['surge_amount'];
    gstAmount = json['gst_amount'];
    rating = json['rating'];
    car_no = json['car_no'];
    driveLat = json['driverlatitude'];
    driveLng = json['driverlongitude'];
    cancel_charge = json['cancel_charge'];
    show = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
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
    data['booking_otp'] = this.bookingOtp;
    data['user_gcm_code'] = this.userGcmCode;
    data['otp_status'] = this.otpStatus;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['user_image'] = this.userImage;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['longnitute'] = this.longnitute;
    data['driver_name'] = this.driverName;
    data['driver_id'] = this.driverId;
    data['driver_image'] = this.driverImage;
    data['driver_contact'] = this.driverContact;
    return data;
  }
}

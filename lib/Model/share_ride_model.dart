class ShareRideModel {
  String? id;
  String? userId;
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

  ShareRideModel(
      {this.id,
      this.userId,
      this.uneaqueId,
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
      this.addOnDistance});

  ShareRideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
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
    return data;
  }
}

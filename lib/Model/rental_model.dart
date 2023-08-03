/// status : true
/// bike_data : [{"id":null,"car_categories":"1","hours":null,"fixed_rate":null,"rate_per_hour":"20","cartype":"","status":null,"cancellation_charges":"20.00","rate_per_km":"20.00","taxes":"10","hours_data":[{"hours":"15","fixed_amount":"100","fixed_km":"50"},{"hours":"30","fixed_amount":"200","fixed_km":"100"}],"car_type_id":null,"car_image":null,"car_model":null,"cab_id":"25","car_name":null}]
/// car_data : [{"id":"47","car_categories":"2","hours":null,"fixed_rate":null,"rate_per_hour":"30","cartype":"47","status":"1","cancellation_charges":"50.00","rate_per_km":"30.00","taxes":"5","hours_data":[{"hours":"30","fixed_amount":"500","fixed_km":"50"}],"car_type_id":"2","car_image":"","car_model":"SUZUKI","cab_id":"26","car_name":"SUZUKI"},{"id":"49","car_categories":"2","hours":null,"fixed_rate":null,"rate_per_hour":"20","cartype":"49","status":"1","cancellation_charges":"20.00","rate_per_km":"20.00","taxes":"2","hours_data":[{"hours":"45","fixed_amount":"600","fixed_km":"25"}],"car_type_id":"2","car_image":null,"car_model":"maruti","cab_id":"27","car_name":"maruti"}]

class RentalModel {
  RentalModel({
    bool? status,
    List<BikeData>? bikeData,
    List<CarData>? carData,
  }) {
    _status = status;
    _bikeData = bikeData;
    _carData = carData;
  }

  RentalModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['bike_data'] != null) {
      _bikeData = [];
      json['bike_data'].forEach((v) {
        _bikeData?.add(BikeData.fromJson(v));
      });
    }
    if (json['car_data'] != null) {
      _carData = [];
      json['car_data'].forEach((v) {
        _carData?.add(CarData.fromJson(v));
      });
    }
  }
  bool? _status;
  List<BikeData>? _bikeData;
  List<CarData>? _carData;
  RentalModel copyWith({
    bool? status,
    List<BikeData>? bikeData,
    List<CarData>? carData,
  }) =>
      RentalModel(
        status: status ?? _status,
        bikeData: bikeData ?? _bikeData,
        carData: carData ?? _carData,
      );
  bool? get status => _status;
  List<BikeData>? get bikeData => _bikeData;
  List<CarData>? get carData => _carData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_bikeData != null) {
      map['bike_data'] = _bikeData?.map((v) => v.toJson()).toList();
    }
    if (_carData != null) {
      map['car_data'] = _carData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "47"
/// car_categories : "2"
/// hours : null
/// fixed_rate : null
/// rate_per_hour : "30"
/// cartype : "47"
/// status : "1"
/// cancellation_charges : "50.00"
/// rate_per_km : "30.00"
/// taxes : "5"
/// hours_data : [{"hours":"30","fixed_amount":"500","fixed_km":"50"}]
/// car_type_id : "2"
/// car_image : ""
/// car_model : "SUZUKI"
/// cab_id : "26"
/// car_name : "SUZUKI"

class CarData {
  CarData({
    String? id,
    String? carCategories,
    dynamic hours,
    dynamic fixedRate,
    String? ratePerHour,
    String? cartype,
    String? status,
    String? cancellationCharges,
    String? ratePerKm,
    String? admin_commission,
    String? taxes,
    List<HoursData>? hoursData,
    String? carTypeId,
    String? carImage,
    String? carModel,
    String? cabId,
    String? carName,
  }) {
    _id = id;
    _admin_commission = admin_commission;
    _carCategories = carCategories;
    _hours = hours;
    _fixedRate = fixedRate;
    _ratePerHour = ratePerHour;
    _cartype = cartype;
    _status = status;
    _cancellationCharges = cancellationCharges;
    _ratePerKm = ratePerKm;
    _taxes = taxes;
    _hoursData = hoursData;
    _carTypeId = carTypeId;
    _carImage = carImage;
    _carModel = carModel;
    _cabId = cabId;
    _carName = carName;
  }

  CarData.fromJson(dynamic json) {
    _id = json['id'];
    _carCategories = json['car_categories'];
    _hours = json['hours'];
    _admin_commission = json['admin_commission'];
    _fixedRate = json['fixed_rate'];
    _ratePerHour = json['rate_per_hour'];
    _cartype = json['cartype'];
    _status = json['status'];
    _cancellationCharges = json['cancellation_charges'];
    _ratePerKm = json['rate_per_km'];
    _taxes = json['taxes'];
    if (json['hours_data'] != null) {
      _hoursData = [];
      json['hours_data'].forEach((v) {
        _hoursData?.add(HoursData.fromJson(v));
      });
    }
    _carTypeId = json['car_type_id'];
    _carImage = json['car_image'];
    _carModel = json['car_model'];
    _cabId = json['cab_id'];
    _carName = json['car_name'];
  }
  String? _id;
  String? _carCategories;
  dynamic _hours;
  dynamic _fixedRate;
  String? _ratePerHour;
  String? _admin_commission;
  String? _cartype;
  String? _status;
  String? _cancellationCharges;
  String? _ratePerKm;
  String? _taxes;
  List<HoursData>? _hoursData;
  String? _carTypeId;
  String? _carImage;
  String? _carModel;
  String? _cabId;
  String? _carName;
  CarData copyWith({
    String? id,
    String? carCategories,
    dynamic hours,
    dynamic fixedRate,
    String? ratePerHour,
    String? cartype,
    String? status,
    String? cancellationCharges,
    String? ratePerKm,
    String? taxes,
    List<HoursData>? hoursData,
    String? carTypeId,
    String? carImage,
    String? carModel,
    String? cabId,
    String? carName,
  }) =>
      CarData(
        id: id ?? _id,
        carCategories: carCategories ?? _carCategories,
        hours: hours ?? _hours,
        fixedRate: fixedRate ?? _fixedRate,
        ratePerHour: ratePerHour ?? _ratePerHour,
        cartype: cartype ?? _cartype,
        status: status ?? _status,
        cancellationCharges: cancellationCharges ?? _cancellationCharges,
        ratePerKm: ratePerKm ?? _ratePerKm,
        taxes: taxes ?? _taxes,
        hoursData: hoursData ?? _hoursData,
        carTypeId: carTypeId ?? _carTypeId,
        carImage: carImage ?? _carImage,
        carModel: carModel ?? _carModel,
        cabId: cabId ?? _cabId,
        carName: carName ?? _carName,
      );
  String? get id => _id;
  String? get carCategories => _carCategories;
  dynamic get hours => _hours;
  dynamic get fixedRate => _fixedRate;
  String? get ratePerHour => _ratePerHour;
  String? get cartype => _cartype;
  String? get admin_commission => _admin_commission;
  String? get status => _status;
  String? get cancellationCharges => _cancellationCharges;
  String? get ratePerKm => _ratePerKm;
  String? get taxes => _taxes;
  List<HoursData>? get hoursData => _hoursData;
  String? get carTypeId => _carTypeId;
  String? get carImage => _carImage;
  String? get carModel => _carModel;
  String? get cabId => _cabId;
  String? get carName => _carName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['car_categories'] = _carCategories;
    map['hours'] = _hours;
    map['fixed_rate'] = _fixedRate;
    map['rate_per_hour'] = _ratePerHour;
    map['cartype'] = _cartype;
    map['status'] = _status;
    map['cancellation_charges'] = _cancellationCharges;
    map['rate_per_km'] = _ratePerKm;
    map['taxes'] = _taxes;
    if (_hoursData != null) {
      map['hours_data'] = _hoursData?.map((v) => v.toJson()).toList();
    }
    map['car_type_id'] = _carTypeId;
    map['car_image'] = _carImage;
    map['car_model'] = _carModel;
    map['cab_id'] = _cabId;
    map['car_name'] = _carName;
    return map;
  }
}

/// hours : "30"
/// fixed_amount : "500"
/// fixed_km : "50"

class HoursData {
  HoursData({
    String? hours,
    String? fixedAmount,
    String? fixedKm,
  }) {
    _hours = hours;
    _fixedAmount = fixedAmount;
    _fixedKm = fixedKm;
  }

  HoursData.fromJson(dynamic json) {
    _hours = json['hours'];
    _fixedAmount = json['fixed_amount'];
    _fixedKm = json['fixed_km'];
  }
  String? _hours;
  String? _fixedAmount;
  String? _fixedKm;
  HoursData copyWith({
    String? hours,
    String? fixedAmount,
    String? fixedKm,
  }) =>
      HoursData(
        hours: hours ?? _hours,
        fixedAmount: fixedAmount ?? _fixedAmount,
        fixedKm: fixedKm ?? _fixedKm,
      );
  String? get hours => _hours;
  String? get fixedAmount => _fixedAmount;
  String? get fixedKm => _fixedKm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hours'] = _hours;
    map['fixed_amount'] = _fixedAmount;
    map['fixed_km'] = _fixedKm;
    return map;
  }
}

/// id : null
/// car_categories : "1"
/// hours : null
/// fixed_rate : null
/// rate_per_hour : "20"
/// cartype : ""
/// status : null
/// cancellation_charges : "20.00"
/// rate_per_km : "20.00"
/// taxes : "10"
/// hours_data : [{"hours":"15","fixed_amount":"100","fixed_km":"50"},{"hours":"30","fixed_amount":"200","fixed_km":"100"}]
/// car_type_id : null
/// car_image : null
/// car_model : null
/// cab_id : "25"
/// car_name : null

class BikeData {
  BikeData({
    dynamic id,
    String? carCategories,
    dynamic hours,
    dynamic fixedRate,
    String? ratePerHour,
    String? cartype,
    dynamic status,
    String? cancellationCharges,
    String? ratePerKm,
    String? taxes,
    String? admin_commission,
    List<HoursData>? hoursData,
    dynamic carTypeId,
    dynamic carImage,
    dynamic carModel,
    String? cabId,
    dynamic carName,
  }) {
    _id = id;
    _carCategories = carCategories;
    _hours = hours;
    _admin_commission = admin_commission;
    _fixedRate = fixedRate;
    _ratePerHour = ratePerHour;
    _cartype = cartype;
    _status = status;
    _cancellationCharges = cancellationCharges;
    _ratePerKm = ratePerKm;
    _taxes = taxes;
    _hoursData = hoursData;
    _carTypeId = carTypeId;
    _carImage = carImage;
    _carModel = carModel;
    _cabId = cabId;
    _carName = carName;
  }

  BikeData.fromJson(dynamic json) {
    _id = json['id'];
    _carCategories = json['car_categories'];
    _hours = json['hours'];
    _admin_commission = json['admin_commission'];
    _fixedRate = json['fixed_rate'];
    _ratePerHour = json['rate_per_hour'];
    _cartype = json['cartype'];
    _status = json['status'];
    _cancellationCharges = json['cancellation_charges'];
    _ratePerKm = json['rate_per_km'];
    _taxes = json['taxes'];
    if (json['hours_data'] != null) {
      _hoursData = [];
      json['hours_data'].forEach((v) {
        _hoursData?.add(HoursData.fromJson(v));
      });
    }
    _carTypeId = json['car_type_id'];
    _carImage = json['car_image'];
    _carModel = json['car_model'];
    _cabId = json['cab_id'];
    _carName = json['car_name'];
  }
  dynamic _id;
  String? _carCategories;
  dynamic _hours;
  dynamic _fixedRate;
  String? _ratePerHour;
  String? _cartype;
  dynamic _status;
  String? _cancellationCharges;
  String? _ratePerKm;
  String? _admin_commission;
  String? _taxes;
  List<HoursData>? _hoursData;
  dynamic _carTypeId;
  dynamic _carImage;
  dynamic _carModel;
  String? _cabId;
  dynamic _carName;
  BikeData copyWith({
    dynamic id,
    String? carCategories,
    dynamic hours,
    dynamic fixedRate,
    String? ratePerHour,
    String? cartype,
    dynamic status,
    String? cancellationCharges,
    String? ratePerKm,
    String? taxes,
    List<HoursData>? hoursData,
    dynamic carTypeId,
    dynamic carImage,
    dynamic carModel,
    String? cabId,
    dynamic carName,
  }) =>
      BikeData(
        id: id ?? _id,
        carCategories: carCategories ?? _carCategories,
        hours: hours ?? _hours,
        fixedRate: fixedRate ?? _fixedRate,
        ratePerHour: ratePerHour ?? _ratePerHour,
        cartype: cartype ?? _cartype,
        status: status ?? _status,
        cancellationCharges: cancellationCharges ?? _cancellationCharges,
        ratePerKm: ratePerKm ?? _ratePerKm,
        taxes: taxes ?? _taxes,
        hoursData: hoursData ?? _hoursData,
        carTypeId: carTypeId ?? _carTypeId,
        carImage: carImage ?? _carImage,
        carModel: carModel ?? _carModel,
        cabId: cabId ?? _cabId,
        carName: carName ?? _carName,
      );
  dynamic get id => _id;
  String? get carCategories => _carCategories;
  dynamic get hours => _hours;
  dynamic get fixedRate => _fixedRate;
  String? get ratePerHour => _ratePerHour;
  String? get cartype => _cartype;
  dynamic get status => _status;
  String? get cancellationCharges => _cancellationCharges;
  String? get ratePerKm => _ratePerKm;
  String? get admin_commission => _admin_commission;
  String? get taxes => _taxes;
  List<HoursData>? get hoursData => _hoursData;
  dynamic get carTypeId => _carTypeId;
  dynamic get carImage => _carImage;
  dynamic get carModel => _carModel;
  String? get cabId => _cabId;
  dynamic get carName => _carName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['car_categories'] = _carCategories;
    map['hours'] = _hours;
    map['fixed_rate'] = _fixedRate;
    map['rate_per_hour'] = _ratePerHour;
    map['cartype'] = _cartype;
    map['status'] = _status;
    map['cancellation_charges'] = _cancellationCharges;
    map['rate_per_km'] = _ratePerKm;
    map['taxes'] = _taxes;
    if (_hoursData != null) {
      map['hours_data'] = _hoursData?.map((v) => v.toJson()).toList();
    }
    map['car_type_id'] = _carTypeId;
    map['car_image'] = _carImage;
    map['car_model'] = _carModel;
    map['cab_id'] = _cabId;
    map['car_name'] = _carName;
    return map;
  }
}

/// hours : "15"
/// fixed_amount : "100"
/// fixed_km : "50"

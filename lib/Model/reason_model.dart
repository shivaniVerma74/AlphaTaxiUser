class ReasonModel {
  String? id;
  String? userType;
  String? reason;
  String? date;

  ReasonModel({this.id, this.userType, this.reason, this.date});

  ReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    reason = json['reason'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['reason'] = this.reason;
    data['date'] = this.date;
    return data;
  }
}

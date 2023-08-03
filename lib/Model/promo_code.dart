class PromoModel {
  String? id;
  String? promocode;
  String? type;
  String? amount;
  String? startdate;
  String? enddate;
  String? status;
  String? discount;
  String? message;

  PromoModel(
      {this.id,
        this.promocode,
        this.type,
        this.amount,
        this.startdate,
        this.enddate,
        this.status,
        this.discount,
        this.message});

  PromoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promocode = json['promocode'];
    type = json['type'];
    amount = json['amount'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    status = json['status'];
    discount = json['discount'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['promocode'] = this.promocode;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['startdate'] = this.startdate;
    data['enddate'] = this.enddate;
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['message'] = this.message;
    return data;
  }
}

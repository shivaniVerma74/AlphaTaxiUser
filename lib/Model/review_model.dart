class ReviewModel {
  String? id;
  String? driverId;
  String? userId;
  String? rating;
  String? comment;
  String? approved;
  String? time;
  String? username;
  String? userImage;

  ReviewModel(
      {this.id,
        this.driverId,
        this.userId,
        this.rating,
        this.comment,
        this.approved,
        this.time,
        this.username,
        this.userImage});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    rating = json['rating'];
    comment = json['comment'];
    approved = json['approved'];
    time = json['time'];
    username = json['username'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['approved'] = this.approved;
    data['time'] = this.time;
    data['username'] = this.username;
    data['user_image'] = this.userImage;
    return data;
  }
}

import 'dart:ui';

class CategoryModel {
  String id, name, image;

  CategoryModel(this.id, this.name, this.image);
}

class TimeModel {
  String id, name, price, km, perKm;

  TimeModel(this.id, this.name, this.price, this.km, this.perKm);
}

class MainModel {
  String id, title, image;
  Color color;
  String url, count, url1;
  int totalCount;
  MainModel(this.id, this.title, this.image, this.color, this.url, this.url1,
      this.count, this.totalCount);
}

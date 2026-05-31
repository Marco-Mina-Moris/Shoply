import 'package:hive/hive.dart';
import 'package:shoply/core/model/response/category_response.dart';

part 'product_response.g.dart';

@HiveType(typeId: 0)
class ProductResponse {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(6)
  String? slug;
  @HiveField(2)
  int? price;
  @HiveField(5)
  String? description;
  CategoryResponse? category;
  @HiveField(4)
  List<String>? images;
  @HiveField(7)
  String? creationAt;
  @HiveField(8)
  String? updatedAt;
  @HiveField(3)
  int quantity = 1;

  ProductResponse({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
    this.creationAt,
    this.updatedAt,
    this.quantity = 1,
  });

  ProductResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null
        ? CategoryResponse.fromJson(json['category'])
        : null;
    if (json['images'] != null) {
      images = (json['images'] as List).map((e) {
        return e.toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .replaceAll('\\', '')
            .trim();
      }).toList();
    }
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
}

class Category {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? creationAt;
  String? updatedAt;

  Category(
      {this.id,
      this.name,
      this.slug,
      this.image,
      this.creationAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['creationAt'] = this.creationAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class CategoryResponse {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? creationAt;
  String? updatedAt;

  CategoryResponse({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.creationAt,
    this.updatedAt,
  });

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    String? imgUrl = json['image'];
    if (imgUrl != null) {
      image = imgUrl
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .replaceAll('\\', '')
          .trim();
    }
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
}

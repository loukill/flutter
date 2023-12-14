class Category {
  String id;
  String title;
  String imageUrl;

  Category({required this.id, required this.title, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      title: json['title'],
      imageUrl: json['image'],
    );
  }
}
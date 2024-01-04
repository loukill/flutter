class Product {
  final String id;
  final String name;
  final String description;
  final double prix;
  final int quantity;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.prix,
    required this.quantity,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      prix: json['prix'],
      quantity: json['quantity'],
      image: json['image'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'prix': prix,
      'quantity': quantity,
      'image': image,
      'category': category,
    };
  }
}

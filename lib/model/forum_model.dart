class ForumModel {
   final String id;
  final String title;
  final String description;
  final String imageUrl; // Image peut être null

  ForumModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] as String, id: '', // Modifiez cette ligne pour utiliser 'image' au lieu de 'imageUrl'
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': imageUrl,
    };
  }
}

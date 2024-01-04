class TextContent {
  final String id;
  final String content;
  final String txtCategoryId;

  TextContent({required this.id, required this.content, required this.txtCategoryId});

  // Obtenez un aperçu du contenu
  String get preview => content.length > 100 ? '${content.substring(0, 100)}...' : content;

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      id: json['_id'],
      content: json['contenu'],
      txtCategoryId: json['txtCategoryId'],
    );
  }
}

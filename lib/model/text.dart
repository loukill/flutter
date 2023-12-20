class Texte {
  final String id;
  final String title;
  final String content;
  final int consultationsCount;
  // Autres champs selon votre modèle

  Texte({
    required this.id,
    required this.title,
    required this.content,
    this.consultationsCount = 0,
  });

    Texte.newText({
    this.id = '',
    required this.title,
    required this.content,
    this.consultationsCount = 0,
  });

   factory Texte.fromJson(Map<String, dynamic> json) {
  return Texte(
    id: json['_id'] ?? '',
    title: json['title'] ?? 'Titre par défaut',
    content: json['contenu'] ?? 'Contenu par défaut',
    consultationsCount: json['consultationsCount'] ?? 0,
  );
}

}

import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/text.dart';

class TextSearchDelegate extends SearchDelegate {
  final List<Texte> textes;
  final Function(String) onSearch;

  TextSearchDelegate(this.textes, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    // Vous pouvez renvoyer un widget personnalisé pour afficher les résultats de la recherche
    return Container(); // Exemple
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions de recherche (facultatif)
    return Container(); // Exemple
  }
}

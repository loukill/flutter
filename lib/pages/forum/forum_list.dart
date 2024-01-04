import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/forum_model.dart';
import 'package:flutter_dashboard/pages/forum/forum_details.dart';
import 'package:flutter_dashboard/service/forumservice.dart';
import 'package:flutter_dashboard/pages/forum/add_forum_form.dart';

class ForumList extends StatefulWidget {
  @override
  _ForumListState createState() => _ForumListState();
}

class _ForumListState extends State<ForumList> {
  final ForumService serviceForum = ForumService('http://localhost:3000');
  List<ForumModel> forums = [];
  List<ForumModel> forumsFiltres = [];

  TextEditingController rechercheController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chargerForums();
  }

  Future<void> chargerForums() async {
    try {
      final List<ForumModel> forumsRecuperes = await serviceForum.getForums();
      setState(() {
        forums = forumsRecuperes;
        forumsFiltres = forums; // Initialisation des forums filtrés avec la liste complète
      });
    } catch (e) {
      print('Erreur lors de la récupération des forums : $e');
    }
  }

  Future<void> ajouterForum() async {
    // Ouvrez le formulaire d'ajout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddForumForm(
          onAdd: (newForum) async {
            // Appeler la méthode addForum du service avec le nouveau forum
            try {
              await serviceForum.addForum(newForum);
              // Si l'ajout réussit, actualiser la liste des forums
              chargerForums();
            } catch (e) {
              // Gérer les erreurs d'ajout du forum
              print('Erreur lors de l\'ajout du forum : $e');
            }
          },
        ),
      ),
    );
  }

  Future<void> _supprimerForum(String forumId) async {
    try {
      await serviceForum.deleteForum(forumId);
      chargerForums();
    } catch (e) {
      print('Erreur lors de la suppression du forum : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Forums'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: chargerForums,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ajouterForum,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: filtrerForums,
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: rechercheController,
            decoration: InputDecoration(
              labelText: 'Rechercher',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  rechercheController.clear();
                  chargerForums();
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: forumsFiltres.length,
              itemBuilder: (context, index) {
                final forum = forumsFiltres[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(forum.imageUrl),
                    ),
                    title: Text(forum.title),
                    subtitle: Text(forum.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumDetails(forum: forum),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _supprimerForum(forum.id); // Remplacez forum.id par le bon champ
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void filtrerForums() {
  String termeRecherche = rechercheController.text.toLowerCase();
  setState(() {
    forumsFiltres = forums.where((forum) =>
        forum.title.toLowerCase().contains(termeRecherche)).toList();
  });
}

}

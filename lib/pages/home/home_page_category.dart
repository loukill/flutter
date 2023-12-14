import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/category/widgets/custon_data_table.dart';

class HomePageCat extends StatelessWidget {
  const HomePageCat({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Tableau de Jeux et Fichiers Texte
        Expanded(
          flex: 1,  // Vous pouvez ajuster la flexibilité selon vos besoins
          child: CustomDataTable(), // Utilisation de votre widget CustomDataTable
        ),
      ],
    );
  }
}

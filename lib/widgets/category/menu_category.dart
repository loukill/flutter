import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/menu_category_model.dart';
import 'package:flutter_dashboard/responsive.dart';

class MenuCat extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MenuCat({super.key, required this.scaffoldKey});

  @override
  _MenuCatState createState() => _MenuCatState();
}

class _MenuCatState extends State<MenuCat> {
  List<MenuCatModel> menu = [
    MenuCatModel(icon: Icons.dashboard, title: 'Tableau de Bord'), // Remplacé avec Icons.dashboard
    MenuCatModel(icon: Icons.games, title: 'Jeux'), // Remplacé avec Icons.games
    MenuCatModel(icon: Icons.description, title: 'Fichiers Texte'), // Remplacé avec Icons.description
    MenuCatModel(icon: Icons.bar_chart, title: 'Statistiques'), // Remplacé avec Icons.bar_chart
    MenuCatModel(icon: Icons.exit_to_app, title: 'Déconnexion'), // Remplacé avec Icons.exit_to_app
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        color: const Color(0xFF171821),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 40 : 80,
              ),
              ...menu.map((menuItem) => _buildMenuItem(menuItem)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuCatModel menuItem) {
    int index = menu.indexOf(menuItem);
    return InkWell(
      onTap: () {
        setState(() {
          selected = index;
        });
        widget.scaffoldKey.currentState!.closeDrawer();
        // Ajoutez ici la logique de navigation
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          color: selected == index
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          child: Row(
            children: [
              Icon(
                menuItem.icon, // Utilisation des icônes Material
                color: selected == index ? Colors.black : Colors.grey,
              ),
              SizedBox(width: 10),
              Text(
                menuItem.title,
                style: TextStyle(
                  fontSize: 16,
                  color: selected == index ? Colors.black : Colors.grey,
                  fontWeight: selected == index ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

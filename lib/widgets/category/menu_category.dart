import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dashboard/model/menu_category_model.dart'; 
import 'package:flutter_dashboard/responsive.dart';

class MenuCat extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MenuCat({super.key, required this.scaffoldKey});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuCat> {
  List<MenuCatModel> menu = [
    MenuCatModel(icon: 'assets/icons/home.svg', title: "Tableau de Bord"),
    MenuCatModel(icon: 'assets/icons/games.svg', title: "Jeux"),
    MenuCatModel(icon: 'assets/icons/files.svg', title: "Fichiers Texte"),
    MenuCatModel(icon: 'assets/icons/statistics.svg', title: "Statistiques"),
    MenuCatModel(icon: 'assets/icons/logout.svg', title: "Déconnexion"),
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
              for (var i = 0; i < menu.length; i++)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                  color: selected == i
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = i;
                    });
                    widget.scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        child: SvgPicture.asset(
                          menu[i].icon,
                          color: selected == i ? Colors.black : Colors.grey,
                        ),
                      ),
                      Text(
                        menu[i].title,
                        style: TextStyle(
                            fontSize: 16,
                            color: selected == i ? Colors.black : Colors.grey,
                            fontWeight: selected == i
                                ? FontWeight.w600
                                : FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
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
          // Ajoutez votre logique de navigation ici
        });
        widget.scaffoldKey.currentState!.closeDrawer();
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
              SvgPicture.asset(
                menuItem.icon,
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

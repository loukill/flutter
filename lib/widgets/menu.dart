import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Responsive.dart';
import 'package:flutter_dashboard/model/menu_modal.dart';
import 'package:flutter_dashboard/screens/product_list.dart';
import 'package:flutter_dashboard/widgets/bibliotheque/artical_form.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_dashboard/pages/category/category_dashboard.dart';

class Menu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Menu({super.key, required this.scaffoldKey});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "Profile"),
    MenuModel(icon: 'assets/svg/exercise.svg', title: "Activity"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "Product"),
    MenuModel(icon: 'assets/svg/history.svg', title: "Bibliotheque"),
    MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
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
          color: const Color(0xFF171821)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 40 : 80,
            ),
            for (var i = 0; i < menu.length; i++)
              buildMenuItem(i),
          ],
        )),
      ),
    );
  }

  Widget buildMenuItem(int i) {
    return InkWell(
      onTap: () {
  if (menu[i].title == "Activity") {
    // Naviguer vers la page d'activité
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryDashboard()), // Remplacez par la page d'activité
    );
  } else if (menu[i].title == "Product") {
    // Naviguer vers la page de produit
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()), // Remplacez ProductPage() par la page de produit
    );
  } else if (menu[i].title == "Bibliotheque") {
    // Naviguer vers la page de produit
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleForm()), // Remplacez ProductPage() par la page de produit
    );
  } 
  else {
    setState(() {
      selected = i;
    });
  }
  widget.scaffoldKey.currentState!.closeDrawer();
},
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
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
                      : FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}